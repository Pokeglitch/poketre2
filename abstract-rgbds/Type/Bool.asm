Type Bool
    method init
      args , value=false
        \1@redef value
        def \1#Initial = \1
    endm

    method reset
      args
        \1@redef \1#Initial
    endm

    method redef
      args
        def \1 = \2
    endm

    method negate
      args
        \1@redef \1 ^ 1
    endm
end

Type True, Bool
    method init
      args
        super true
    endm
end

Type False, Bool
    method init
      args
        super false
    endm
end
