use warp::Filter;

#[tokio::main]
async fn main() {
    // GET /hello/warp => 200 OK with body "Hello, warp!"
    let hello = warp::path!("hello" / String)
        .map(|name| format!("Hello, {}!", name));

    println!("Time to serve up :3030");
    warp::serve(hello)
        .run(([0, 0, 0, 0], 3030))
        .await;
}
