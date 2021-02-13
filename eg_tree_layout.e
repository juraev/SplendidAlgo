note
	description: "Arrange the nodes in a tree."
	legal: "See notice at end of class."
	status: "See notice at end of class."
	date: "$Date: 2010-12-08 17:55:59 +0100 (Wed, 08 Dec 2010) $"
	revision: "$Revision: 85085 $"

class
	EG_TREE_LAYOUT

inherit
	EG_LAYOUT
		redefine
			default_create
		end

create
	make_with_world_and_root

feature {NONE} -- Initialization

	make_with_world_and_root (w: EG_FIGURE_WORLD; a_root: EG_NODE)
		require
			w.has_node_figure (a_root)
		do
			make_with_world (w)
			root_node := a_root
		end

	default_create
			-- Create a EG_GRID_LAYOUT.
		do
			Precursor {EG_LAYOUT}
			exponent := 1.0
		end

feature -- Access

	root_node: EG_NODE

	point_x: INTEGER
			-- The x position of the start of the tree.

	point_y: INTEGER
			-- The y position of the start of the tree.

	exponent: DOUBLE
--			-- Exponent used to reduce grid width per level.
--			-- (`grid_width' / cluster_level ^ `exponent').

feature -- Element change

	set_point_position (ax, ay: INTEGER)
			-- Set `point_a_x' to `ax' and `point_a_y' to `ay'.
		do
			point_x := ax
			point_y := ay
		ensure
			set: point_x = ax and point_y = ay
		end

	set_exponent (an_exponent: like exponent)
			-- Set `exponent' to `an_exponent'.
		do
			exponent := an_exponent
		ensure
			set: exponent = an_exponent
		end

feature {NONE} -- Implementation

	layout_linkables (linkables: ARRAYED_LIST [EG_LINKABLE_FIGURE]; level: INTEGER; cluster: detachable EG_CLUSTER_FIGURE)
			-- arrange `linkables'.
		local
			d_x: INTEGER
			start_x, start_y: INTEGER
			n: EG_NODE
		do
			start_x := point_x
			d_x := 0
			start_y := point_y

			debug ("tree")
				print ("ROOT%N")
			end
			n := root_node
			layout_tree_node (start_x, start_y, create {CELL [INTEGER]}.put (start_x) ,n, linkables)
		end

	layout_tree_node (pos_x, pos_y: INTEGER; last_x: CELL [INTEGER] n: EG_NODE; linkables: ARRAYED_LIST [EG_LINKABLE_FIGURE])
		local
			fig: EG_FIGURE
			l_count, i, start_x, start_y: INTEGER
			ln: EG_LINK
			w: INTEGER
		do
			start_x := pos_x
			start_y := pos_y

			fig := figure_from_node (n, linkables)
			if fig /= Void then
				fig.set_point_position (start_x, start_y)

--				l_count := n.links.count
				l_count := 0
				i := 0
				across
					n.links as ic
				loop
					ln := ic.item
					if ln.source = n then
						l_count := l_count + 1
						if
							attached {EG_NODE} ln.target as tgt and then
							attached figure_from_node (tgt, linkables) as m
						then
							if w > 0 then
								w := w + 20
							end
							w := w + m.bounding_box.width
						end
					end
				end
				debug ("tree")
					if attached n.name_32 as s then
						print (n.id.out + " " + s.to_string_8  + " w=" + w.out + "%N")
					else
						print (n.id.out + " w=" + w.out + "%N")
					end
				end
				if l_count > 0 then
					start_y := start_y + 100
					if l_count > 1 then
						start_x := start_x
					end
					across
						n.links as ic
					loop
						ln := ic.item
						if
							ln.source = n and then
							attached {EG_NODE} ln.target as l_node and then
							attached {EG_LINKABLE_FIGURE} figure_from_node (l_node, linkables) as l_linkable
						then

							i := i + 1
	--						l_linkable.set_point_position (start_x - l_count * 100 + (i - 1) * 100, start_y)
	--						l_linkable.set_port_position (start_x - l_count * 100 + (i - 1) * 100, start_y)

							last_x.replace (start_x)
							debug ("tree")
								print ("  - start_x=" + start_x.out + " node width=" + l_linkable.bounding_box.width.out + "%N")
							end
							layout_tree_node (last_x.item, start_y, last_x, l_node, linkables)
							start_x := last_x.item + 20
--							if l_count /= 1 then
--								start_x := last_x.item + fig.bounding_box.width
--							end
						end
					end
					start_x := start_x - 20
				else
					start_x := start_x + fig.bounding_box.width
				end
			end
			last_x.replace (start_x)
			debug ("tree")
				if attached n.name_32 as s then
					print (n.id.out + " " + s.to_string_8  + " - end at start_x=" + start_x.out + "%N")
				else
					print (n.id.out + " - end at start_x=" + start_x.out + "%N")
				end
			end
		end

	figure_from_node (a_node: EG_NODE; a_list: ITERABLE [EG_FIGURE]): detachable EG_FIGURE
		do
			across
				a_list as ic
			until
				Result /= Void
			loop
				if ic.item.model = a_node then
					Result := ic.item
				end
			end
		end

note
	copyright:	"Copyright (c) 1984-2010, Eiffel Software and others"
	license:	"Eiffel Forum License v2 (see http://www.eiffel.com/licensing/forum.txt)"
	source: "[
			Eiffel Software
			5949 Hollister Ave., Goleta, CA 93117 USA
			Telephone 805-685-1006, Fax 805-685-6869
			Website http://www.eiffel.com
			Customer support http://support.eiffel.com
		]"




end -- class EG_GRID_LAYOUT

