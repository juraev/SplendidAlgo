note
	description: "Objects that shows node name within an ellipse."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	author: "Benno Baumgartner"
	date: "$Date: 2009-09-24 06:47:41 +0200 (Thu, 24 Sep 2009) $"
	revision: "$Revision: 80863 $"

class
	ELLIPSE_NODE

inherit
	EG_SIMPLE_NODE
		redefine
			color,
			update,
			default_create,
			figure_size,
			xml_node_name
		end

create
	make_with_model

create {EG_SIMPLE_NODE}
	make_filled

feature {NONE} -- Initialization

	default_create
			-- Create an EG_SIMPLE_NODE.
		do
			fig_size := 30
			create color.make_with_rgb (.4, .8, .2)
			Precursor {EG_SIMPLE_NODE}
			bring_to_front (name_label)
			node_figure.set_radius1 (figure_size)
			node_figure.set_radius2 (figure_size // 2)
			node_figure.set_background_color (color)
			disable_scaling
			disable_rotating
			set_center
		end

feature -- Access

	xml_node_name: STRING
			-- Name of `xml_element'.
		do
			Result := "ELLIPSE_NODE"
		end

feature -- Element change

	update
			-- Some properties may have changed.
		do
			if is_label_shown then
				name_label.set_x_y (point_x, point_y)
			end
			is_update_required := False
		end

	set_color (col: EV_COLOR)
		do
			color := col
			node_figure.set_background_color (col)
		end

	set_size (sz: INTEGER)
		do
			fig_size := sz
		end


feature {MAIN_WINDOW} -- Implementation

	color: EV_COLOR assign set_color

	fig_size: INTEGER
--			-- color of figure.
--		once
--			create Result.make_with_rgb (.4, .8, .2)
--		end

	figure_size: INTEGER
			-- Size of figure in pixel.
		do
			Result := fig_size
		end

note
	copyright:	"Copyright (c) 1984-2006, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			 Eiffel Software
			 356 Storke Road, Goleta, CA 93117 USA
			 Telephone 805-685-1006, Fax 805-685-6869
			 Website http://www.eiffel.com
			 Customer support http://support.eiffel.com
		]"


end -- class ELLIPSE_NODE
