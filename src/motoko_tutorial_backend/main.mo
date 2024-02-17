import Map "mo:base/HashMap";
import Hash "mo:base/Hash";
import Nat "mo:base/Nat";
import Iter "mo:base/Iter";
import Text "mo:base/Text";

// Define the actor
actor Assistant {

    type ToDo = {
        description: Text;
        completed: Bool;
        priority: Nat; // Öncelik seviyesi eklendi
        deadline: Nat; // Son kullanma tarihi eklendi
    };

    func natHash(n : Nat) : Hash.Hash { 
        Text.hash(Nat.toText(n))
    };

    var todos = Map.HashMap<Nat, ToDo>(0, Nat.equal, natHash);
    var nextId : Nat = 0;

    public query func getTodos() : async [ToDo] {
        Iter.toArray(todos.vals());
    };

    // Returns the ID that was given to the ToDo item
    public func addTodo(description : Text, priority: Nat, deadline: Nat) : async Nat { // Öncelik ve son kullanma tarihi parametre olarak eklendi
        let id = nextId;
        todos.put(id, { description = description; completed = false; priority = priority; deadline = deadline });
        nextId += 1;
        id
    };

    public func completeTodo(id : Nat) : async () {
        ignore do ? {
            let description = todos.get(id)!.description;
            todos.put(id, { description; completed = true; priority = todos.get(id)!.priority; deadline = todos.get(id)!.deadline });
        }
    };

    public query func showTodos() : async Text {
        var output : Text = "\n___TO-DOs___";
        for (todo : ToDo in todos.vals()) {
            output #= "\n" # todo.description;
            if (todo.completed) {
                output #= " ✔"; 
            };
            output #= " (Priority: " # Nat.toText(todo.priority) # ", Deadline: " # Nat.toText(todo.deadline) # ")"; // Öncelik ve son kullanma tarihi gösterildi
        };
        output # "\n"
    };

    public func clearCompleted() : async () {
        todos := Map.mapFilter<Nat, ToDo, ToDo>(todos, Nat.equal, natHash, 
        func(_, todo) {if (todo.completed) null else ?todo });
    };

    // Bir ToDo öğesini silmek için
    public func deleteTodo(id: Nat): async () {
        ignore do ? {
            todos.remove(id);
        }
    };
    
    // Tüm tamamlanan ToDo öğelerini temizlemek için
    public func clearAllTodos(): async () {
        todos := Map.mapFilter<Nat, ToDo, ToDo>(todos, Nat.equal, natHash,
            func(_, todo) { if (todo.completed) null else ?todo });
    };
}
