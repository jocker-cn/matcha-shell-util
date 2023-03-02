mod actuator;
mod command;
mod executor;
mod constant;
mod utils;

use std::{env, path};
use std::fs::{create_dir_all, File};
use std::path::Path;
use std::thread::Thread;
use std::time::Duration;
use utils::util::*;
use crate::executor::executor::{Executor, Noop, Scheduler, Installer};
use crate::actuator::Operator;
// use std::process::{Command};


fn main(){
    // let request_args: Vec<String> = env::args().collect();

    // let url = "https://download.docker.com/linux/static/stable/x86_64/docker-23.0.1.tgz";

}

