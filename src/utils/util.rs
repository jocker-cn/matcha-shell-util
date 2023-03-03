use std::collections::HashMap;
use std::{env, fs};
use std::fs::{create_dir_all, File, metadata, Metadata, Permissions};
use std::path::Path;
use std::process::{Command, Output};
use crate::actuator::Operator;


pub fn is_executable(filename: &str) -> bool {
    if is_file(filename) {
        let meta = file_metadata(filename);
        let permissions = meta.permissions();

    }
    return false;
}

pub fn file_metadata(filename: &str) -> Metadata {
    return metadata(filename).unwrap();
}

pub fn sh(sd: dir, args: Vec<String>, msg: &str) -> Output {
    return Command::new(sd).args(args).output().expect(msg);
}

pub fn create_file(filename: &str, is_file: bool) -> bool {
    if !is_file {
        return create_dir_all(filename).is_ok();
    }

    let mut flag = is_file;
    if let Some(parent) = Path::new(filename).parent() {
        flag = create_dir_all(parent).is_ok();
    }
    if flag {
        return File::create(filename).is_ok();
    }
    return flag;
}

pub fn is_file(filename: &str) -> bool {
    let re = fs::metadata(Path::new(filename));
    return re.is_ok() && re.unwrap().is_file();
}

pub fn is_dir(filename: &str) -> bool {
    let re = fs::metadata(Path::new(filename));
    return re.is_ok() && re.unwrap().is_dir();
}

pub fn set_env_value_map(map: HashMap<String, String>) {
    if !map.is_empty() {
        for (key, value) in map {
            set_env_value(key, value);
        }
    }
}

pub fn set_env_value(key: String, value: String) {
    env::set_var(key, value);
}

pub fn get_env_value(key: String) -> String {
    return result_get_default(env::var(key), "None".to_string());
}

pub fn result_get_default<T, E: std::fmt::Debug>(r: Result<T, E>, default: T) -> T {
    return match r {
        Ok(val) => {
            val
        }
        Err(e) => {
            default
        }
    };
}
