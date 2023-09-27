//----------------------------------------------------------//
//    FILE: prototype.sv
//    AUTHOR:
//
//    ABSTRACT: 
//    KEYWORDS: 
//
//    MODIFICATION HISTORY: 
//    $Log$
//
//----------------------------------------------------------//

// abstract class
virtual class Prototype;
    pure virtual function Prototype clone();
    pure virtual function void display();
endclass

// concrete class
class ConcretePrototype extends Prototype;
    string name;
    //
    function new(string name="");
        this.name = name;
    endfunction
    //
    virtual function Prototype clone();
        ConcretePrototype cp = new();
        cp.name = this.name;
        return cp;
    endfunction
    //
    virtual function void display();
        $display("name = %s", this.name);
    endfunction
endclass

// tb top
module tb_top;
    initial begin
        ConcretePrototype cp = new("hello");
        Prototype p = cp.clone();
        p.display();
    end
endmodule
