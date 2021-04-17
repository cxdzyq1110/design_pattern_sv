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
class fruit;
  static local fruit   m_self = null  ; // this local member should be static
  static local string  m_name = ""    ;

  // new function should be proteced
  protected function new();
  endfunction

  virtual function string set_name(string name);
    m_name = name;
  endfunction

  virtual function string get_name();
    return m_name;
  endfunction

  // this function should be static
  static function fruit get();
    if(m_self==null)
      m_self = new();
    return m_self;
  endfunction
endclass

module tb_top;
  initial
  begin
    fruit a = fruit::get();
    a.set_name("hello");
    $display(a.get_name());
  end
  //initial
  //begin
  //  fruit b = new();
  //  b.set_name("hello");
  //  $display(b.get_name());
  //end
endmodule

