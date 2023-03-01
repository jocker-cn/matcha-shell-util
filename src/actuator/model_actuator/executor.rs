use crate::actuator::model_actuator::{Operator, ShellArgs};

pub trait Executor {
    fn executor(wp: * Wrapper) {}
}


pub struct Wrapper {
    executor: * dyn Executor,
    model: * str,
    exec_args: * Vec<String>,
    exec_file: * str,
}

pub struct Noop;


impl Executor for Noop {
    fn executor(wp: * Wrapper) {
        //NOOP
    }
}

struct Installer;

impl Executor for Installer {
    fn executor(wp: * Wrapper) {
        //todo install
    }
}

struct Scheduler;

impl Executor for Scheduler {
    fn executor(wp: * Wrapper) {
        //NOOP
    }
}


pub fn match_executor(op: * Operator, sa: *const Vec<str>) -> Box<dyn Executor> {

}

fn test() {
    let scheduler = Scheduler::from();
}