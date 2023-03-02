use std::collections::HashMap;
use std::process::{Command, Output};
use crate::actuator::{ShellArgs, Operator};
use crate::executor;


pub struct CommandAdapter {}

impl CommandAdapter {
    pub fn new(sa: ShellArgs) -> Self {
        Self {}
    }
}

pub struct CommandWrapper {
    sh_dir: String,
    //执行的脚本全路径
    command: Command, // 封装完成的命令(包括执行参数 环境变量 输入输出定义等)
}

impl CommandWrapper {
    pub fn new(sh_dir: String, command: Command) -> Self {
        Self { sh_dir, command }
    }

    pub fn executor(&mut self, error_msg: &String) -> CommandResult {
        let command = &mut self.command;
        let out_put = command.output().expect(error_msg);
        return CommandResult::new(out_put);
    }
}


pub struct CommandResult {
    // 封装完成的命令(包括执行参数 环境变量 输入输出定义等)
    result: Output,
}

impl CommandResult {
    pub fn new(result: Output) -> Self {
        Self { result }
    }
}


struct CommandArgs {
    //脚本路径
    sh_dir: String,
    //环境变量
    env_map: HashMap<String, String>,
    // 执行参数
    args: Vec<String>,
}

impl CommandArgs {
    fn new(sh_dir: String, env_map: HashMap<String, String>, args: Vec<String>) -> Self {
        Self { sh_dir, env_map, args }
    }

    pub fn new2(sh_dir: String, env_map: HashMap<String, String>, args: String) -> Self {
        Self { sh_dir, env_map, args: Vec::from([args]) }
    }
}


trait CommandCreator {
    fn create(ca: CommandArgs) -> CommandWrapper;
}

struct CommandCreatorSupport;

impl CommandCreator for CommandCreatorSupport {
    fn create(ca: CommandArgs) -> CommandWrapper {
        let sh_dir = ca.sh_dir;
        let re_args = ca.args;
        let env = ca.env_map;
        let mut command = Command::new(sh_dir.clone());
        if !env.is_empty() {
            command.envs(env);
        }
        if !re_args.is_empty() {
            command.args(re_args);
        }
        return CommandWrapper::new(sh_dir, command);
    }
}

fn test() {

    // Command::new().env()
    //     .output()
    // Command::new().env().into()
    // Command::new().env().fmt()
    // Command::new().env().try_into()
    // Command::new().env().deref().output().expect();
}