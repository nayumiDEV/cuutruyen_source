use captcha::Captcha;
use captcha::filters::{Noise, Wave, Dots, Grid};
use rand::seq::IteratorRandom;
use rand::Rng;

fn main() {
    let mut rng = rand::thread_rng();

    let words_dict = include_str!("./words.csv");

    let words_vec = words_dict.trim().split("\n");
    let chosen_word = words_vec.choose(&mut rand::thread_rng()).unwrap();

    let text: Vec<char> = chosen_word.chars().collect();

    let img = Captcha::new()
        .add_custom_chars(text)
        .apply_filter(Grid::new(rng.gen_range(5..20), rng.gen_range(5..20)))
        .apply_filter(Wave::new(3.0, 18.0).horizontal())
        .apply_filter(Wave::new(3.0, 18.0).vertical())
        .apply_filter(Noise::new(0.4))
        .view(390, 120)
        // .apply_filter(
        //     Cow::new()
        //         .min_radius(20)
        //         .max_radius(60)
        //         .circles(2)
        //         .area(Geometry::new(40, 150, 50, 70)))
        .apply_filter(Dots::new(rng.gen_range(4..7)))
        .as_base64().unwrap();
        // .save(std::path::Path::new("captcha.png")).unwrap();

    println!("{}|{}", chosen_word, img);
}
