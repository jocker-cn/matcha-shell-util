use crate::command::command_executor::{CommandAdapter, CommandWrapper, CommandResult};

use crate::actuator::{Operator, ShellArgs};

pub fn executor(c: &ShellArgs) {
    //获取对应的执行器
}

pub trait Executor {
    fn executor(wp: CommandWrapper) {}
}


pub struct Noop;


impl Executor for Noop {
    fn executor(wp: CommandWrapper) {
        //NOOP
    }
}

pub struct Installer;

impl Executor for Installer {
    fn executor(wp: CommandWrapper) {
        //todo install
    }
}

pub struct Scheduler;

impl Executor for Scheduler {
    fn executor(wp: CommandWrapper) {
        //NOOP
    }
}