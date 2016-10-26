%include 'inc/func.inc'
%include 'class/class_vector.inc'
%include 'class/class_error.inc'
%include 'class/class_lisp.inc'

	def_func class/lisp/func_copy
		;inputs
		;r0 = lisp object
		;r1 = args
		;outputs
		;r0 = lisp object
		;r1 = value

		ptr this, args
		ulong length

		push_scope
		retire {r0, r1}, {this, args}

		devirt_call vector, get_length, {args}, {length}
		if {length == 1}
			func_call vector, get_element, {args, 0}, {args}
			if {args->obj_vtable == @class/class_vector}
				devirt_call vector, get_length, {args}, {length}
				devirt_call vector, slice, {args, 0, length}, {args}
				func_call vector, for_each, {args, 0, length, $callback, 0}, {_}
			else
				func_call ref, ref, {args}
			endif
		else
			func_call error, create, {"(copy form) wrong number of args", args}, {args}
		endif

		eval {this, args}, {r0, r1}
		pop_scope
		return

	callback:
		;inputs
		;r0 = predicate data pointer
		;r1 = element iterator
		;outputs
		;r1 = 0 if break, else not

		pptr iter
		ptr pdata
		ulong length

		push_scope
		retire {r0, r1}, {pdata, iter}

		assign {*iter}, {pdata}
		if {pdata->obj_vtable == @class/class_vector}
			devirt_call vector, get_length, {pdata}, {length}
			devirt_call vector, slice, {pdata, 0, length}, {pdata}
			func_call vector, for_each, {pdata, 0, length, $callback, 0}, {_}
			func_call ref, deref, {*iter}
			assign {pdata}, {*iter}
		endif

		eval {1}, {r1}
		pop_scope
		return

	def_func_end