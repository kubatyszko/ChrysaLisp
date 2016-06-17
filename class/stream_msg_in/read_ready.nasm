%include 'inc/func.inc'
%include 'class/class_stream_msg_in.inc'

	fn_function class/stream_msg_in/read_ready
		;inputs
		;r0 = stream_msg_in object
		;outputs
		;r0 = stream_msg_in object
		;r1 = 0 if data not available
		;trashes
		;all but r0, r4

		;extend test to include mailbox
		p_call stream_msg_in, read_ready, {r0}, {r1}
		if r1, ==, 0
			vp_cpy [r0 + stream_msg_in_list + lh_list_head], r1
			vp_cpy [r1 + ln_node_succ], r1
		endif
		vp_ret

	fn_function_end