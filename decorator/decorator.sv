/*----------------------------------------------------------*\
    FILE: decorator.sv
    AUTHOR:

    ABSTRACT: 
    KEYWORDS: 

    MODIFICATION HISTORY: 
    $Log$

\*----------------------------------------------------------*/

virtual class abstract_component;
    protected string m_name;

    function new();
    endfunction

    virtual function void set_name(string name);
        m_name = name;
    endfunction

    virtual function string get_name();
        return m_name;
    endfunction

    virtual function void operate();
        $display("unknown!");
    endfunction
endclass

class concrete_component extends abstract_component;
    virtual function void operate();
        $display(get_name(), " start to paint");
    endfunction
endclass

class decorator extends abstract_component;
    protected abstract_component m_comp;
    virtual function void set_comp(abstract_component comp);
        m_comp = comp;
    endfunction

    virtual function void decorate();
        $display("decorate");
    endfunction

    virtual function void operate();
        decorate();
        m_comp.operate();
    endfunction
endclass

class border_decorator extends decorator;
    virtual function void decorate();
        $display("border_decorator");
        super.decorate();
    endfunction
endclass

//////////////////////////////////////////
module tb_top;

    initial begin
        concrete_component comp = new();
        border_decorator dec = new();
        comp.set_name("hello");
        dec.set_comp(comp);
        dec.operate();
    end

endmodule
