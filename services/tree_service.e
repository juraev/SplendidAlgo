note
	description: "Summary description for {TREE_CONTROLLER}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	TREE_SERVICE

create
	make


feature

	make
		do
			create graph
			create root; root.set_name_32("Root")
			graph.add_node (root)

			create dfs_stack.make(0)
		end

	add_node (ax, ay: INTEGER): EG_NODE
			-- Add a new node to `graph' position it at (`ax', `ay') in `world'.
		local
			new_node: EG_NODE
		do
			node_counter := node_counter + 1

			-- Create the node
			create new_node
			new_node.set_name_32 ("NODE_" + node_counter.out)

			-- Add it to the graph
			graph.add_node (new_node)

			Result := new_node

		end

	add_link (n1, n2: EG_LINKABLE)
			-- Add a link to `graph' connecting `n1' with `n2'.
		require
			n1_not_void: n1 /= Void
			n2_not_void: n2 /= Void
		local
			link: EG_LINK
		do
			create link.make_directed_with_source_and_target (n1, n2)
			graph.add_link (link)
		end

	add_random_nodes (nb: INTEGER)
			-- Add `nb' nodes to the graph.
		local
			i: INTEGER
			n: EG_NODE

		do
			from
				i := 1
			until
				i > nb
			loop
				n := add_node (random.next_item_in_range (0, 300), random.next_item_in_range (0, 300))
				i := i + 1
				add_link (root, n)
			end
		end

	new_world_tree: EG_NODE
		local
			colors: EV_STOCK_COLORS
			n1, n2, n11, n12, n13, n121, n1211,
				n21, n22, n23, n231, n232, n233: EG_NODE
			ln: EG_LINK
		do

			graph.wipe_out
			create root; root.set_name_32("Root")

			create colors

			create n1; n1.set_name_32 ("1")
			create n2; n2.set_name_32 ("2")
			create n11; n11.set_name_32 ("1.1")
			create n12; n12.set_name_32 ("1.2")
			create n13; n13.set_name_32 ("1.3")
			create n121; n121.set_name_32 ("1.2.1")
			create n1211; n1211.set_name_32 ("1.2.1.1")

			create n21; n21.set_name_32 ("2.1")
			create n22; n22.set_name_32 ("2.2")
			create n23; n23.set_name_32 ("2.3")
			create n231; n231.set_name_32 ("2.3.1")
			create n232; n232.set_name_32 ("2.3.2")
			create n233; n233.set_name_32 ("2.3.3")

			graph.add_node (root)
			graph.add_node (n1)
			graph.add_node (n2)
			graph.add_node (n11)
			graph.add_node (n12)
			graph.add_node (n13)
			graph.add_node (n121)
			graph.add_node (n1211)

			graph.add_node (n21)
			graph.add_node (n22)
			graph.add_node (n23)
			graph.add_node (n231)
			graph.add_node (n232)
			graph.add_node (n233)

			create ln.make_directed_with_source_and_target (root, n1); graph.add_link (ln)
			create ln.make_directed_with_source_and_target (root, n2); graph.add_link (ln)
			create ln.make_directed_with_source_and_target (n1, n11); graph.add_link (ln)
			create ln.make_directed_with_source_and_target (n1, n12); graph.add_link (ln)
			create ln.make_directed_with_source_and_target (n1, n13); graph.add_link (ln)
			create ln.make_directed_with_source_and_target (n12, n121); graph.add_link (ln)
			create ln.make_directed_with_source_and_target (n121, n1211); graph.add_link (ln)

			create ln.make_directed_with_source_and_target (n2, n21); graph.add_link (ln)
			create ln.make_directed_with_source_and_target (n2, n22); graph.add_link (ln)
			create ln.make_directed_with_source_and_target (n2, n23); graph.add_link (ln)
			create ln.make_directed_with_source_and_target (n23, n231); graph.add_link (ln)
			create ln.make_directed_with_source_and_target (n23, n232); graph.add_link (ln)
			create ln.make_directed_with_source_and_target (n23, n233); graph.add_link (ln)

			Result := root

			dfs(root)
			dfs_stack.move (1)

		end

	dfs(cur: EG_NODE)
		do
			dfs_stack.extend(cur)

			print(cur.name_32)

			across cur.links as ic loop
				if attached {EG_NODE}ic.item.target as node and then ic.item.source = cur then
					dfs(node)
				end
			end
		end

	next_on_dfs: EG_NODE
		do
			Result := dfs_stack.item
			dfs_stack.forth
		end

	random: RANGED_RANDOM
		once
			create Result.make
		end

feature

	graph: EG_GRAPH

	root: EG_NODE

	node_counter: INTEGER

	dfs_stack: ARRAYED_LIST[EG_NODE]

end
