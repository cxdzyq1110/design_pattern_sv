/*----------------------------------------------------------*\
    FILE: decorator.sv
    AUTHOR:

    ABSTRACT: 
    KEYWORDS: 

    MODIFICATION HISTORY: 
    $Log$

\*----------------------------------------------------------*/
class abstract_item;
    rand int x;
endclass

virtual class abstract_constraint #(type T=int);
    protected T m_inst;
    virtual function void set_inst(T inst);
        m_inst = inst;
    endfunction
endclass

`define constraint_utils(T) \
    local rand abstract_constraint#(T) m_cons[$]; \
    virtual function add_cons_inst(abstract_constraint#(T) cons); \
        cons.set_inst(this); \
        m_cons.push_back(cons); \
    endfunction

class concrete_item extends abstract_item;
    `constraint_utils(abstract_item)
endclass

class concrete_cons_neq_10 extends abstract_constraint#(abstract_item);
    constraint cons {
        m_inst.x != 10;
    }
endclass

class concrete_cons_gte_10 extends abstract_constraint#(abstract_item);
    constraint cons {
        m_inst.x >= 10;
    }
endclass

class concrete_cons_lte_10 extends abstract_constraint#(abstract_item);
    constraint cons {
        m_inst.x <= 10;
    }
endclass

`undef constraint_utils


//////////////////////////////////////////
module tb_top;

   initial begin
        concrete_item item = new();
        concrete_cons_neq_10 cons_neq_10 = new();
        concrete_cons_gte_10 cons_gte_10 = new();
        concrete_cons_lte_10 cons_lte_10 = new();
        item.add_cons_inst(cons_gte_10);
        item.add_cons_inst(cons_lte_10);
        //item.add_cons_inst(cons_neq_10);
        assert (item.randomize())
        else
            $fatal("item randomize failed!");
        $display("x = %0d", item.x);
    end

endmodule
