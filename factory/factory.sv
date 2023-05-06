//----------------------------------------------------------//
//    FILE: factory.sv
//    AUTHOR:
//
//    ABSTRACT: 
//    KEYWORDS: 
//
//    MODIFICATION HISTORY: 
//    $Log$
//
//----------------------------------------------------------//

// base abstract class for object
virtual class object;
    pure virtual function void display();
    // get_type_name() can be overrided by macro definition
    pure virtual function string get_type_name();
    // create() and get_type() should be implemented with registry
    pure virtual function object create();
    pure virtual function object get_type();
endclass

// singleton for factory
class factory;
    static local factory me = null; // this protected member should be static
    protected object m_objects [string];

    // new function should be proteced
    protected function new();
        m_objects.delete();
    endfunction

    // this function should be static
    static function factory get();
        if (me==null) begin
            me = new();
            $display("%0t --> Create factory instance", $time);
        end
        return me;
    endfunction

    // store prototype of object's subclassing
    virtual function void register(object obj, string type_name);
        if (m_objects.exists(type_name)) begin
            $fatal("object %s already registered!", type_name);
        end else begin
            m_objects[type_name] = obj;
            $display("%s is registered!", type_name);
        end
    endfunction

    // create object
    virtual function object create(string type_name);
        if (m_objects.exists(type_name)) begin
            object obj = m_objects[type_name].create();
            $display("%s is created!", type_name);
            return obj;
        end else begin
            $fatal("object %s never registered!", type_name);
        end
    endfunction

    // type override
    virtual function void override(object src, object dst);
        if (src==null || dst==null) begin
            $fatal("null object cannot be override!");
        end else begin
            string type_name = src.get_type_name();
            m_objects[type_name] = dst;
            $display("%s overrided to %s!", src.get_type_name(), dst.get_type_name());
        end
    endfunction

endclass

// define a register class
class registry#(type T=object, string S="object");
    typedef registry#(T, S) this_type;
    //
    static local this_type me = null; // this protected member should be static
    // m_obj is protected, and prototype for T object, name is S
    static protected T m_obj = new();
    // new function should be proteced
    protected function new();
    endfunction

    // this function should be static
    static function this_type get();
        if (me==null) begin
            factory f = factory::get();
            me = new();
            // register into factory
            f.register(m_obj, S);
        end
        return me;
    endfunction

    // added create static method
    static function T create();
        T obj = new();
        return obj;
    endfunction

    // added get_type static method
    static function object get_type();
        return m_obj;
    endfunction
endclass

// use macro definition for factory
`define _register(T) \
    typedef registry#(T, `"T`") type_id; \
    protected static type_id m_type_id = type_id::get(); \
    virtual function string get_type_name(); \
        return `"T`"; \
    endfunction \
    virtual function T create(); \
        return type_id::create(); \
    endfunction \
    virtual function object get_type(); \
        return type_id::get_type(); \
    endfunction

// define subclass for object
class CompA extends object;
    `_register(CompA)

    virtual function void display();
        $display("this is CompA");
    endfunction
endclass

class CompB extends object;
    `_register(CompB)

    virtual function void display();
        $display("this is CompB");
    endfunction
endclass

class CompC extends object;
    `_register(CompC)

    virtual function void display();
        $display("this is CompC");
    endfunction
endclass
// tb top

module tb_top;
    initial begin
        factory f = factory::get();
        object objA = f.create("CompA");
        object objB = CompB::type_id::get_type();
        object objC;
        f.override(CompC::type_id::get_type(), CompA::type_id::get_type());
        objA.display();
        objB.display();
        objC = f.create("CompC");
        objC.display();
    end
endmodule
