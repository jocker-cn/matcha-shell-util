mod executor;

use executor::{Executor, Noop, match_executor};

pub enum Operator {
    INSTALL {
        ac: Noop
    },
    SCHEDULE{

    },
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
            op = Operator::INSTALL { ac: Noop };
        } else {
            op = Operator::OTHER;
        }
        Self { model, args, op }
    }
}

pub trait Actuator {
    fn executor() {}
}

impl Actuator for NoopActuator {
    fn executor() {
        //NOOP
    }
}

// 根据入参选择执行器
pub trait Match {
    fn choose_actuator(r: Vec<String>) -> dyn Actuator;
}


impl Match {
    pub fn name() {}
}
