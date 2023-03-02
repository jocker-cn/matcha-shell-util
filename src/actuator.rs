
// pub trait RequestParser {
//     fn parse(args: Vec<str>) ;
// }
//
//
// impl RequestParser for dyn RequestParser {
//     fn parse(args: Vec<str>)  {
//         //
//     }
// }

#[derive(PartialEq, Eq)]
pub enum Operator {
    INSTALL,
    SCHEDULE,
    OTHER,
}

pub struct ShellArgs {
    model: String,
    args: Vec<String>,
    op: Operator,
}

impl ShellArgs {
    pub fn new(model: String, args: Vec<String>) -> Self {
        let op;
        if model.is_empty() {
            op = Operator::OTHER;
        } else if model.eq_ignore_ascii_case("install") {
            op = Operator::INSTALL;
        } else {
            op = Operator::SCHEDULE;
        }
        Self { model, args, op }
    }

    pub fn model(&self) -> &str {
        &self.model
    }
    pub fn args(&self) -> &Vec<String> {
        &self.args
    }
    pub fn op(&self) -> &Operator {
        &self.op
    }
}

