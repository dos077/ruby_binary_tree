class Node
    attr_accessor :value, :left, :right

    def initialize(value, left=nil, right=nil)
        @value = value
        @left = left
        @right = right
    end

    def to_s
        left = (@left)? @left.value : "\s"
        right = (@right)? @right.value : "\s"
        "(#{left})<=(#{@value})=>(#{right})"
    end

end

class BinaryTree
    attr_reader :root

    def initialize(*values)
        @root = balance_build(values.sort)
    end

    def insert(value, target)
        return target unless value
        return Node.new(value) unless target
        if (value < target.value )
            target.left = insert(value, target.left)
        else
            target.right = insert(value, target.right)
        end
        target
    end

    def balance_build(array)
        mid = array.size/2
        left = array.slice(0...mid)
        right = array.slice((mid+1)...array.size)
        root = Node.new(array[mid])
        if array.size <= 3
            root = insert(left[0], root) if left
            root = insert(right[0], root) if right
        else
            root.left = balance_build(left)
            root.right = balance_build(right)
        end
        root
    end

    def breath_first_search(value)
        parents=[@root]
        until parents.empty?
            children = []
            parents.each do |node|
                return node if value == node.value
                children << node.left if node.left
                children << node.right if node.right
            end
            parents = children
        end
        false
    end

    def depth_first_search(value)
        stack = [{node: @root, left: false}]
        while stack
            node = stack.last[:node]
            left = stack.last[:left]
            if !left && branch = node.left
                stack.last[:left] = true
                stack << {node: branch, left: false}
            else
                return node if value == node.value
                branch = node.right if node.right
                stack.pop
                stack << {node: branch, left: false} if branch
            end
        end
    end

    def dfs_rec(value, node=@root)
        return nil unless node
        result = nil
        if result = dfs_rec(value, node.left)
            return result
        end
        return node if node.value == value
        if result = dfs_rec(value, node.right)
            return result
        end
    end

    def show_tree
        lines = []
        width = 1
        parents = [@root]
        until parents.empty?
            line = ""
            children = []
            width.times do |index|
                if node = parents[index]
                    line+= "(#{node.value})"
                    children[index*2] = node.left if node.left
                    children[index*2+1] = node.right if node.right
                else
                    line+="( )"
                end
            end
            lines << line
            width*=2
            parents=children
        end
        line_width = lines.last.length
        lines.each { |line| puts line.center line_width }
    end

end

def build_tree(array)
    def branching(array)
        return nil if array.empty?
        root = array.size / 2
        left = branching( array.slice(0...root) )
        right = branching( array.slice( (root+1)...array.size) )
        Node.new(array[root], left, right )
    end
    
    root = branching(array.sort)    
end

tree = BinaryTree.new(1, 7, 4, 23, 8, 9, 4, 3, 5, 7, 9, 67, 6345, 324)

puts tree.dfs_rec(6345).to_s