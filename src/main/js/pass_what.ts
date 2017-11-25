// ts-node ./src/main/js/pass_what.ts

class A {
    v : string;
    constructor(s:string){
        this.v=s
    }
}

function pass_pointer(p1, p2){
    p1.v = "changed"
    p2 = new A("changed")
}
{
    let a1 = new A("unchanged")
    let a2 = new A("unchanged")
    pass_pointer(a1, a2);
    console.log(a1.v); // changed
    console.log(a2.v); // unchanged
}

{
    let a1 = {"v":"unchanged"}
    let a2 = {"v":"unchanged"}
    pass_pointer(a1, a2);
    console.log(a1.v); // changed
    console.log(a2.v); // unchanged
}



