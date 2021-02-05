use rocket::routes;

mod api;

/// 构造一个新的Rocket实例。
///
/// 该函数负责附加应用程序的所有路由和处理程序。
pub fn rocket_factory() -> Result<rocket::Rocket, String> {
	let rocket = rocket::ignite().mount("/", routes![api::index::index]);
	Ok(rocket)
}
