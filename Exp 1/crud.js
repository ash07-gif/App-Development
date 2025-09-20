
// CRUD Operations in JavaScript
let arr = [];

// CREATE
function createItem(item) {
    arr.push(item);
    console.log("Item added:", item);
}

// READ
function readItems() {
    console.log("Array contents:", arr);
}

// UPDATE
function updateItem(index, newItem) {
    if (index >= 0 && index < arr.length) {
        console.log("Item updated:", arr[index], "to", newItem);
        arr[index] = newItem;
    } else {
        console.log("Invalid index");
    }
}

// DELETE
function deleteItem(index) {
    if (index >= 0 && index < arr.length) {
        console.log("Item deleted:", arr[index]);
        arr.splice(index, 1);
    } else {
        console.log("Invalid index");
    }
}

// Demo
createItem("Apple");
createItem("Banana");
readItems();
updateItem(1, "Mango");
readItems();
deleteItem(0);
readItems();
