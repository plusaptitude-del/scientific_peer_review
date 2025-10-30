// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

/**
 * @title Blockchain for Scientific Peer Review Auditing
 * @dev A decentralized system for storing, tracking, and verifying peer reviews of scientific papers.
 */
contract Project {
    struct Review {
        uint256 id;
        address reviewer;
        string paperHash;
        string comments;
        uint8 rating; // 1-5 scale
        uint256 timestamp;
    }

    mapping(uint256 => Review) public reviews;
    uint256 public reviewCount;

    event ReviewSubmitted(uint256 indexed id, address indexed reviewer, string paperHash, uint8 rating);
    event ReviewUpdated(uint256 indexed id, string newComments, uint8 newRating);

    /**
     * @dev Submit a new peer review.
     * @param paperHash IPFS or SHA256 hash of the paper being reviewed.
     * @param comments Reviewer comments.
     * @param rating Rating between 1–5.
     */
    function submitReview(string memory paperHash, string memory comments, uint8 rating) public {
        require(rating >= 1 && rating <= 5, "Rating must be 1 to 5");

        reviewCount++;
        reviews[reviewCount] = Review({
            id: reviewCount,
            reviewer: msg.sender,
            paperHash: paperHash,
            comments: comments,
            rating: rating,
            timestamp: block.timestamp
        });

        emit ReviewSubmitted(reviewCount, msg.sender, paperHash, rating);
    }

    /**
     * @dev Update existing review by the original reviewer.
     * @param id Review ID.
     * @param newComments Updated comments.
     * @param newRating Updated rating (1–5).
     */
    function updateReview(uint256 id, string memory newComments, uint8 newRating) public {
        require(id > 0 && id <= reviewCount, "Invalid review ID");
        Review storage review = reviews[id];
        require(msg.sender == review.reviewer, "Only reviewer can update");
        require(newRating >= 1 && newRating <= 5, "Rating must be 1 to 5");

        review.comments = newComments;
        review.rating = newRating;
        review.timestamp = block.timestamp;

        emit ReviewUpdated(id, newComments, newRating);
    }

    /**
     * @dev Get review details by ID.
     * @param id Review ID.
     */
    function getReview(uint256 id) public view returns (Review memory) {
        require(id > 0 && id <= reviewCount, "Invalid review ID");
        return reviews[id];
    }
}

