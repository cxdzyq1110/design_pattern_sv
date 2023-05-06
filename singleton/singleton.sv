/*----------------------------------------------------------*\
        FILE: singleton.sv
        AUTHOR:

        ABSTRACT: 
        KEYWORDS: 

        MODIFICATION HISTORY: 
        $Log$

\*----------------------------------------------------------*/

// local means: sub-classes cannot access this variable
// protected means: external functions cannot access
class singleton;
    static local singleton me = null; // this local member should be static
    protected string m_name = "";

    // new function should be proteced
    protected function new();
    endfunction

    virtual function void set_name(string name);
        m_name = name;
    endfunction

    virtual function string get_name();
        return m_name;
    endfunction

    // this function should be static
    static function singleton get();
        if (me==null) begin
            me = new();
            $display("%0t --> Create singleton instance", $time);
        end
        return me;
    endfunction
endclass

module tb_top;
    initial begin
        fork
            begin: thread_1
                singleton a = singleton::get();
                a.set_name("hello");
                $display(a.get_name());
            end
            begin: thread_2
                singleton b = singleton::get();
                b.set_name("world");
                $display(b.get_name());
            end
        join
    end
    //initial begin
    //    singleton b = new();
    //    b.set_name("hello");
    //    $display(b.get_name());
    //end
endmodule

