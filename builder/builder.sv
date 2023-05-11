//----------------------------------------------------------//
//    FILE: builder.sv
//    AUTHOR:
//
//    ABSTRACT: 
//    KEYWORDS: 
//
//    MODIFICATION HISTORY: 
//    $Log$
//
//----------------------------------------------------------//
    
//
`define _decl_protected_member_(name, type) \
    protected type m_``name; \
    virtual function void set_``name(type name); \
        this.m_``name = name; \
    endfunction \
    virtual function type get_``name(); \
        return this.m_``name; \
    endfunction
//
class Product;
    `_decl_protected_member_(CompA, string)
    `_decl_protected_member_(CompB, string)
    `_decl_protected_member_(CompC, string)
    virtual function void print();
        $display("CompA = ", get_CompA());
        $display("CompB = ", get_CompB());
        $display("CompC = ", get_CompC());
    endfunction
endclass
//
virtual class Builder;
    `_decl_protected_member_(name, string)
    //
    protected Product m_product = new();
    //
    function new(string name);
        this.m_name = name;
    endfunction
    //
    pure virtual function void buildA();
    pure virtual function void buildB();
    pure virtual function void buildC();
    virtual function Product get_product();
        return m_product;
    endfunction
endclass

//
class ConcreteBuilder extends Builder;
    //
    function new(string name);
        super.new(name);
    endfunction
    //
    virtual function void buildA();
        $display(get_name(), " buildA...");
        m_product.set_CompA(get_name());
    endfunction
    //
    virtual function void buildB();
        $display(get_name(), " buildB...");
        m_product.set_CompB(get_name());
    endfunction
    //
    virtual function void buildC();
        $display(get_name(), " buildC...");
        m_product.set_CompC(get_name());
    endfunction
endclass

// base abstract class for object
class Director;
    `_decl_protected_member_(name, string)
    `_decl_protected_member_(builder, Builder)
    //
    function new(string name);
        this.m_name = name;
    endfunction
    //
    virtual function Product constrct();
        $display(get_name(), " is calling ", m_builder.get_name());
        this.m_builder.buildA();
        this.m_builder.buildB();
        this.m_builder.buildC();
        return this.m_builder.get_product();
    endfunction
endclass


// tb top
module tb_top;
    initial begin
        Director director = new("SHU-D320");
        ConcreteBuilder builder1 = new("Player1");
        ConcreteBuilder builder2 = new("Player2");
        director.set_builder(builder1);
        director.set_builder(builder2);
        director.constrct().print();
    end
endmodule
