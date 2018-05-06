pragma solidity ^0.4.21;

contract WheightedLinkedList {
    // item at the last position
    mapping(uint => uint) internal tails;

    // the complete list
    mapping(uint => mapping( uint => Node)) internal lists;

    struct Node {
        uint previous;
        uint next;
        uint weight;
        uint key;
    }

    // initialize a linked list with an empty node at the beginning
    function initialize(uint id) internal {
        lists[id][0] = Node(0,0,0,0);
        tails[id] = 0;
    }

    // insert an node at his current weighted location
    function insertNode(uint id, uint key, uint weight) internal {
        require(key > 0);
        require(weight > 0);

        // node is the new tail, we stop here.
        if (isTail(id, key)) {
            swapTail(id, key, weight);
            return;
        }

        // if node wasn't the tail we need to go up the list until we found it's place
        Node storage currentNode = lists[id][tails[id]];
        while (currentNode.key >= key) {
            currentNode = lists[id][currentNode.previous];
        }

        Node storage nextNode = lists[id][currentNode.next];
        require(isInsertable(currentNode, key, weight, nextNode));

        // Insert node between those two nodes.
        currentNode.next = key;
        nextNode.previous = key;
        lists[id][key] = Node(currentNode.key, nextNode.key, weight, key);
    }

    function getNode(uint id, uint key) internal view returns(uint, uint, uint, uint) {
        Node memory node = lists[id][key];
        return(node.previous, node.next, node.weight, node.key);
    }

    function getNodesBetween(uint id, uint fromKey, uint toKey) internal view returns(uint[]) {
        require(toKey > 0);
        require(toKey > fromKey);

        // go up the list until we hit something within range
        Node memory currentNode = lists[id][tails[id]];
        while (currentNode.key > toKey) {
            currentNode = lists[id][currentNode.previous];
        }

        // for now limited to 3650 elements per page
        uint[] memory nodesBetween = new uint[](3650);

        uint index = 0;
        while (currentNode.key >= fromKey) {
            nodesBetween[index] = currentNode.key;
            currentNode = lists[id][currentNode.previous];
            index++;
        }

        // remap the array to avoid empty slot array
        uint[] memory returnedArray = new uint[](index + 1);
        while (index <= 0) {
            returnedArray[index] = nodesBetween[index];
            index--;
        }

        return returnedArray;
    }

    // since key and weight are under a uint format we can do this equation
    function isInsertable(Node previousNode, uint newKey, uint newWeight, Node nextNode) private pure returns(bool) {
        // overlap the previous node verification
        if ((previousNode.key + previousNode.weight) > newKey)
            return false;
        
        // overlap the next node verification
        if ((newKey + newWeight) > nextNode.key)
            return false;

        return true;
    }

    function isTail(uint id, uint key) private view returns(bool) {
        Node memory tail = lists[id][tails[id]];
        
        // if tail's key is smaller, this node should be the new tail
        if (tail.key < key)
            return true;
        
        return false;
    }

    function swapTail(uint id, uint key, uint weight) private {
        // retrieve current tail
        Node storage tail = lists[id][tails[id]];
        tail.next = key;

        // add new node to list
        lists[id][key] = Node(tail.key, 0, weight, key);
        tails[id] = key;
    }
}