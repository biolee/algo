use std::string::String;
use std::rc::Rc;
use std::sync::Arc;

struct A<'a> {
    v: &'a mut String,
}

const CHANGED: String = String::from("changed");
const UNCHANGED: String = String::from("unchanged");

fn pass_value(p1: A, mut p2: A) {
    p1.v = &mut CHANGED.clone();
    p2 = A { v:&mut CHANGED.clone() };
}

fn pass_immutable_reference(p1: &A, p2: &A) {
    p1.v = &mut CHANGED.clone();

    //  reassign immutable var
    //    p2 = A{v:"changed"};
}

fn pass_mut_reference(p1: &mut A, p2: &mut A) {
    p1.v = &mut CHANGED.clone();
    p2 = &mut A { v: &mut CHANGED.clone() };
}

fn pass_pointer( p1: *mut A, mut p2: *const A) {
    unsafe {
        (*p1).v = &mut CHANGED.clone();
    }

    p2 = & A { v: &mut CHANGED.clone() };
}

fn pass_box(p1: Box<A>, mut p2: Box<A>) {
    p1.v = &mut CHANGED.clone();
    p2 = Box::new(A { v: &mut CHANGED.clone() });
}

fn pass_rc(p1: Rc<A>, mut p2: Rc<A>) {
    p1.v = &mut CHANGED.clone();
    p2 = Rc::new(A { v: &mut CHANGED.clone() });
}

fn pass_arc(p1: Arc<A>, mut p2: Arc<A>) {
    p1.v = &mut CHANGED.clone();
    p2 = Arc::new(A { v: &mut CHANGED.clone() });
}

fn main() {
    {
        let a1 = A { v:&mut UNCHANGED.clone() };
        let a2 = A { v:&mut UNCHANGED.clone() };
        pass_value(a1, a2);
        print!("{}", a1.v);
        print!("{}", a2.v);
    }

    {
        let a1 = A { v:&mut UNCHANGED.clone() };
        let a2 = A { v:&mut UNCHANGED.clone() };
        pass_immutable_reference(&a1, &a2);
        print!("{}", a1.v);
        print!("{}", a2.v);
    }
}