// ToDo Project
import Map "mo:base/HashMap";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Text "mo:base/Text";

actor Assistant {
    type ToDo = {
        description: Text;
        completed: Bool;
    };

    // HashMap
    func natHash(n: Nat) : Hash.Hash {
        Text.hash(Nat.toText(n))
    };

    var todos = Map.HashMap<Nat, ToDo>(0, Nat.equal, natHash);
    var nextId : Nat = 0;

    // assign ID
    public query func addTodo(description: Text) : async Nat {
        let id = nextId;
        todos.put(id, {description = description; completed = false});
        nextId += 1;
        id
    };

    // assign Todo
    public func completeTodo(id: Nat) : async () {
        ignore do ? {
            let description = todos.get(id)!.description;
            todos.put(id, {description; completed = true});
        }
    };

    public query func showTodos() : async Text {
        var output : Text = "\n___TO-DOs___\n";

        for (id, todo) in Iter.toSeq(todos) {
            output = Text.concat(output, Text.concat(Nat.toText(id), Text.concat(": ", Text.concat(todo.description, Text.concat(" (", Text.concat(Bool.toText(todo.completed), ")\n")))));
        }

    };
}