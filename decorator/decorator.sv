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

virtual class decorator extends abstract_component;
    protected abstract_component m_comp;
    virtual function void set_comp(abstract_component comp);
        m_comp = comp;
    endfunction

    virtual function void operate();
        m_comp.operate();
    endfunction
endclass

class border_decorator extends decorator;
    virtual function void added_behav();
        $display("add border!");
    endfunction

    virtual function void operate();
        added_behav();
        super.operate();
    endfunction
endclass

class scroller_decorator extends decorator;
    virtual function void added_behav();
        $display("add scroller!");
    endfunction

    virtual function void operate();
        added_behav();
        super.operate();
    endfunction
endclass

//////////////////////////////////////////
module tb_top;

    initial begin
        concrete_component comp = new();
        border_decorator border = new();
        scroller_decorator scroller = new();
        comp.set_name("hello");
        border.set_comp(comp);
        scroller.set_comp(border);
        scroller.operate();
    end

endmodule
