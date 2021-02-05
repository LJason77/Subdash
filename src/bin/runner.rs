#[rocket::main]
async fn main() -> Result<(), String> {
	let rocket = subdash::rocket_factory().unwrap();
	rocket.launch().await.unwrap();
	Ok(())
}
