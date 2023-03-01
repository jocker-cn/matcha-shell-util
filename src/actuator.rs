mod model_actuator;

use model_actuator::Actuator;


pub trait RequestParser {
    fn parse(args: Vec<str>) -> dyn Actuator;
}


impl RequestParser for dyn RequestParser {

    fn parse(args: &Vec<&str>) -> Box<dyn Actuator> {

    }



}
