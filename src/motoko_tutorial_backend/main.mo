// ToDo Project
import Text "mo:base/Text";
import Nat "mo:base/Nat";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";

actor Assistant {
    type ToDo = {
        description: Text;
        completed: Bool;
    };

    // HashMap
    func natHash(n: Nat) : Hash.Hash {
        Text.hash(Nat.toText(n));
    };

    var todos = Map.HashMap<Nat, Todo>(0, Nat.equal, natHash);
    var nextId : Nat = 0;

    // assign ID to ToDo
    public query func addTodo(description: Text) : async Nat {
        let id = nextId;
        todos.put(id, {description = description; completed = false});
        nextId += 1;
    };

    // assign to update ToDo
    public func completeTodo(id: Nat) : async () {
        ignore do ? {
            let description = todos.get(id)!.description;
            todos.put(id, {description; completed = true});
        }
    };

    public query func showTodos() : async Text {
        var output : Text = "\n___TO-DOs___";

        
    };
}