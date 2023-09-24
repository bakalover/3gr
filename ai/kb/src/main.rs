use std::{collections::HashMap, io::stdin, rc::Rc, time::Duration};
use substring::Substring;
use suiron::*;

enum Era {
    Ancient,
    Medieval,
    Classical,
    Renaissance,
}

fn match_era(likes: &str) -> Option<Era> {
    match likes {
        "древние вещи" => Some(Era::Ancient),
        "старьё" => Some(Era::Ancient),
        "классическое" => Some(Era::Classical),
        "технологичное" => Some(Era::Renaissance),
        "современное" => Some(Era::Renaissance),
        "жечь ведьм" => Some(Era::Medieval),
        _ => None,
    }
}

fn get_era_name(era: Era) -> String {
    match era {
        Era::Ancient => String::from("Ancient"),
        Era::Medieval => String::from("Medieval"),
        Era::Classical => String::from("Classical"),
        Era::Renaissance => String::from("Renaissance"),
    }
}

fn get_diff_name(diff: &Difficulty) -> String {
    match diff {
        Difficulty::Easy => String::from("Easy"),
        Difficulty::Medium => String::from("Medium"),
        Difficulty::Hard => String::from("Hard"),
        Difficulty::Nightmare => String::from("Nightmare"),
    }
}

enum Difficulty {
    Easy,
    Medium,
    Hard,
    Nightmare,
}

fn match_diff(diff: &str) -> Option<Difficulty> {
    match diff {
        "невероятно сложным" => Some(Difficulty::Nightmare),
        "сложным" => Some(Difficulty::Hard),
        "умеренным" => Some(Difficulty::Medium),
        "простым" => Some(Difficulty::Easy),
        _ => None,
    }
}

fn aqcuire_raw_query() -> String {
    match stdin().lines().next() {
        Some(query_res) => match query_res {
            Ok(query) => query,
            Err(_) => {
                panic!("Ошибки при чтении запроса!");
            }
        },
        None => {
            panic!("Пустой запрос!");
        }
    }
}

//Format: "люблю [], хотел бы заниматься чем-то []"
fn parse_tokens(s: &str) -> Option<(Era, Difficulty)> {
    let binding = s.to_lowercase();
    let model = binding.as_str();
    let token_strings: Vec<&str> = model.split(",").collect();
    if token_strings.len() != 2 {
        return None;
    }
    let tokens = (
        &token_strings[0].substring(6, token_strings[0].len() - 1),
        &token_strings[1].substring(28, token_strings[1].len() - 1),
    );
    match_era(tokens.0).and_then(|era| match_diff(tokens.1).and_then(|diff| Some((era, diff))))
}

fn get_techs_by_era(era: Era, kb: &HashMap<String, Vec<Rule>>) -> Vec<String> {
    let in_era = atom!("in_era");
    let tech = logic_var!("Tech");
    let era = atom!(get_era_name(era).as_str());
    let query = query!(in_era, tech, era);
    solve_all(make_base_node(Rc::clone(&query), kb))
}

fn filter_techs(
    techs: &[String],
    diff_val: Difficulty,
    kb: &HashMap<String, Vec<Rule>>,
) -> Vec<String> {
    techs
        .iter()
        .filter(|tech| {
            let tech_q = atom!(tech);
            let diff = atom!("diff");
            let diff_val = atom!(get_diff_name(&diff_val).as_str());
            let query = query!(diff, tech_q, diff_val);
            solve(make_base_node(Rc::clone(&query), kb)) == ""
        })
        .map(|s| s.clone())
        .collect()
}

fn main() {
    let mut kb = KnowledgeBase::new();
    load_kb_from_file(&mut kb, "./base.pl");

    loop {
        let raw_query = aqcuire_raw_query();
        let token_opts = match parse_tokens(&raw_query) {
            None => {
                println!("К сожалению, мы не знаем таких предпочтений :(");
                continue;
            }
            Some(tokens) => tokens,
        };

        let techs: Vec<String> = get_techs_by_era(token_opts.0, &kb)
            .iter()
            .map(|s| s.substring(7, s.len()).to_owned())
            .collect();

        let techs_with_diff = filter_techs(&techs, token_opts.1, &kb);

        println!("Думаем");
        println!(".");
        std::thread::sleep(Duration::from_secs(1));
        println!(".");
        std::thread::sleep(Duration::from_secs(1));
        println!(".");
        std::thread::sleep(Duration::from_secs(1));

        let mut ans = String::from("Вам подойдут следующие технологии для изучения: ");
        techs_with_diff
            .iter()
            .map(|s| {
                ans.push_str(s.as_str());
                ans.push(' ');
            })
            .fold((), |_, _| {});
        println!("{}", ans);

        println!()
    }

    // люблю древние вещи, хотел бы заниматься чем-то сложным
    // люблю современное, хотел бы заниматься чем-то невероятно сложным
}
