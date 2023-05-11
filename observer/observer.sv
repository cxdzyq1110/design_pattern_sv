//----------------------------------------------------------//
//    FILE: observer.sv
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
virtual class Observer;
    `_decl_protected_member_(name, string)
    //
    function new(string name);
        this.m_name = name;
    endfunction
    //
    pure virtual function void update();
endclass

// base abstract class for object
virtual class Subject;
    protected Observer m_observers[string];
    `_decl_protected_member_(name, string)
    //
    function new(string name);
        this.m_name = name;
    endfunction
    //
    virtual function void attach(Observer observer, string name);
        if (m_observers.exists(name)&&m_observers[name]!=null) begin
            $fatal(name, " already exists in ", get_name());
        end else begin
            m_observers[name] = observer;
            $display(observer.get_name(), " joins ", get_name());
        end
    endfunction
    //
    virtual function void detach(string name);
        if (!m_observers.exists(name)||m_observers[name]==null) begin
            $fatal(name, " not exists in ", get_name());
        end else begin
            $display(m_observers[name].get_name(), " leaves ", get_name());
            m_observers[name] = null;
        end
    endfunction
    //
    virtual function void notify(Observer observer);
        foreach (m_observers[name]) begin
            if (name!=observer.get_name()&&m_observers[name]!=null) begin
                m_observers[name].update();
            end
        end
    endfunction
endclass
//
class ConcreteSubject extends Subject;
    `_decl_protected_member_(state, string)
    //
    function new(string name);
        super.new(name);
    endfunction
endclass

//
class ConcreteObserver extends Observer;
    //
    function new(string name);
        super.new(name);
    endfunction
    //
    virtual function void update();
        $display(get_name(), " is on the road...");
    endfunction
    //
    virtual function void attack(Subject subject);
        $display(get_name(), " wants to attack, calling team ", subject.get_name());
        subject.notify(this);
    endfunction
endclass


// tb top
module tb_top;
    initial begin
        ConcreteSubject team = new("SHU-D320");
        ConcreteObserver player1 = new("Player1");
        ConcreteObserver player2 = new("Player2");
        ConcreteObserver player3 = new("Player3");
        team.attach(player1, player1.get_name());
        team.attach(player2, player2.get_name());
        team.attach(player3, player3.get_name());
        player3.attack(team);
    end
endmodule
