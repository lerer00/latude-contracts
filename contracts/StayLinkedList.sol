pragma solidity ^0.4.18;

contract StayLinkedList {
    mapping(uint => uint) internal tails;
    mapping(uint => mapping( uint => Node)) internal lists;

    struct Node {
        uint previous;
        uint next;
        // Unix epoch format that represent the duration of the stay.
        uint weight;
        // Start date under unix epoch format.
        uint key;
    }

    function initializeAssetList(uint assetId) internal {
        lists[assetId][0] = Node(0,0,0,0);
        tails[assetId] = 0;
    }

    function insertNode(uint assetId, uint key, uint weight) internal {
        require(key > 0);
        require(weight > 0);

        // There's always a tail.
        Node storage currentNode = lists[assetId][tails[assetId]];

        // Node is the new tail, we stop here.
        if (isTail(currentNode, key)) {
            appendTail(assetId, currentNode, key, weight);
            return;
        }

        // We go up the list until we find his place.
        while (currentNode.key >= key) {
            currentNode = lists[assetId][currentNode.previous];
        }

        Node storage nextNode = lists[assetId][currentNode.next];
        require(isInsertable(currentNode, key, weight, nextNode));

        // Insert node between those two nodes.
        currentNode.next = key;
        nextNode.previous = key;
        lists[assetId][key] = Node(currentNode.key, nextNode.key, weight, key);
    }

    function getNode(uint assetId, uint key) internal view returns(uint, uint, uint, uint) {
        Node memory node = lists[assetId][key];
        return(node.previous, node.next, node.weight, node.key);
    }

    // This function is public for us to gather availabilities.
    function getNodesBetween(uint assetId, uint from, uint to) public constant returns(uint[]) {
        require(to > 0);
        require(to > from);

        // For now we can on check for 64 days.
        require((to - from) <= 64 * 60 * 60 * 24); 

        // Go up the list until we hit something within range.
        Node memory currentNode = lists[assetId][tails[assetId]];
        while (currentNode.key > to) {
            currentNode = lists[assetId][currentNode.previous];
        }

        uint[] memory nodesBetween = new uint[](64);
        uint index = 0;
        while (currentNode.key >= from) {
            nodesBetween[index] = currentNode.key;
            currentNode = lists[assetId][currentNode.previous];
            index++;
        }

        return nodesBetween;
    }

    // Check if node is the current or new tail.
    function isTail(Node node, uint key) private pure returns(bool) {
        if (node.key < key)
            return true;
        
        return false;
    }

    // Since key and weight are under a unix epoch format we can do this equation. 
    function isInsertable(Node previousNode, uint newKey, uint newWeight, Node nextNode) private pure returns(bool) {
        // Does it overlap the previousNode?
        if ((previousNode.key + previousNode.weight) > newKey)
            return false;
        
        // Does it overlap the nextNode?
        if ((newKey + newWeight) > nextNode.key)
            return false;

        return true;
    }

    function appendTail(uint assetId, Node storage previousNode, uint key, uint weight) private {
        previousNode.next = key;
        lists[assetId][key] = Node(previousNode.key, 0, weight, key);
        tails[assetId] = key;
    }
}