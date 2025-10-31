use axum::{
    routing::get,
    Router,
    response::Json,
    http::StatusCode,
};
use std::net::SocketAddr;
use serde::Serialize;

#[derive(Serialize)]
struct Message {
    message: String,
    status: String,
}

#[tokio::main]
async fn main() {
    let app = Router::new()
        .route("/", get(root))
        .route("/hello", get(hello))
        .route("/health", get(health_check));

    let addr = SocketAddr::from(([127, 0, 0, 1], 3000));
    
    println!("Server launched on http://{}", addr);

    let listener = tokio::net::TcpListener::bind(addr).await.unwrap();
    axum::serve(listener, app).await.unwrap();
}

async fn root() -> &'static str {
    "Welcome to simple HTTP сервер!"
}

async fn hello() -> Json<Message> {
    Json(Message {
        message: "Hello, world!".to_string(),
        status: "success".to_string(),
    })
}

async fn health_check() -> (StatusCode, Json<Message>) {
    let message = Message {
        message: "Server works ok".to_string(),
        status: "healthy".to_string(),
    };
    (StatusCode::OK, Json(message))
}
