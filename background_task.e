note
	description: "Summary description for {BACKGROUND_TASK}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	BACKGROUND_TASK

create
	make


feature

	make(a_window: separate MAIN_WINDOW)
		do
			window := a_window
		end

	do_separately
		local
			is_finished: BOOLEAN
		do
			from

			until
				is_finished
			loop

				{EXECUTION_ENVIRONMENT}.sleep (1000000000)
				separate window as w do
					w.on_next
					is_finished := w.is_algo_finished
				end
			end
		end

feature

	window: separate MAIN_WINDOW

end
