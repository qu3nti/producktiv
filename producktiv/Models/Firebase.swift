//
//  ModelData.swift
//  producktiv
//
//  Created by Quentin Pompliano on 1/9/23.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth
import SwiftUI

final class Firebase: ObservableObject {
    
    @Published var userData = UserModel(
        id: "",
        firstName: "",
        lastName: "",
        userName: "",
        email: "",
        icon: "",
        newNotifications: false
    )
    
    @Published var signInError = false
    @Published var signUpError = false
    
    @Published var tasks = [TaskModel]()
    @Published var todos = [ToDoModel]()
    @Published var friends = [UserModel]()
    private var friendIds = [String]()
    @Published var feed = [PostModel]()
    @Published var feedLoaded = false
    
    @Published var sentRequests = [UserModel]()
    @Published var friendRequests = [UserModel]()
    @Published var notifications = [NotificationModel]()
    
    
    @Published var viewingFriends = [UserModel]()
    @Published var viewingTodos = [ToDoModel]()
    @Published var viewingTasks = [TaskModel]()
    @Published var viewingComments = [CommentModel]()
    @Published var viewingLikes = [LikeModel]()
    @Published var viewingUser = UserModel(
        id: "",
        firstName: "",
        lastName: "",
        userName: "",
        email: "",
        icon: "",
        newNotifications: false
    )
    
    @Published var searchedPeople = [UserModel]()
    
    private var db = Firestore.firestore()
    private var taskListener: FirebaseFirestore.ListenerRegistration?
    private var toDoListener: FirebaseFirestore.ListenerRegistration?
    private var userListener: FirebaseFirestore.ListenerRegistration?
    private var friendListener: FirebaseFirestore.ListenerRegistration?
    private var friendRequestListener: FirebaseFirestore.ListenerRegistration?
    private var pendingFriendsListener: FirebaseFirestore.ListenerRegistration?
    private var feedListener: FirebaseFirestore.ListenerRegistration?
    private var notificationListener: FirebaseFirestore.ListenerRegistration?


    
    var user: User? {
        didSet {
            objectWillChange.send()
        }
    }
    
    /*
     Suggestions and Bug Reports
     */
    
    func reportBug(description: String) {
        let id = UUID().uuidString

        db.collection("bugs").document(id).setData([
            "id": id,
            "report": description,
            "reporter": self.userData.userName,
            "timestamp": Timestamp(date: Date()),
        ]) { err in
            if let err = err {
                print("Error reporting bug by \(self.userData.id): \(err)")
            } else {
                print("Bug successfully reported by \(self.userData.id)!")
            }
        }

    }
    
    func giveSuggestion(suggestion: String) {
        let id = UUID().uuidString

        db.collection("suggestions").document(id).setData([
            "id": id,
            "report": suggestion,
            "reporter": self.userData.userName,
            "timestamp": Timestamp(date: Date()),
        ]) { err in
            if let err = err {
                print("Error sugggesting suggestion by \(self.userData.id): \(err)")
            } else {
                print("Suggestion successfully suggested by \(self.userData.id)!")
            }
        }
    }
    
    
    /*
     * User-related functions
     */
    
    func fetchUsers(query: String) {
        db.collection("users").whereField("userName", isGreaterThanOrEqualTo: query.lowercased())
            .whereField("userName", isLessThanOrEqualTo:  "\(query.lowercased())uf8ff")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error getting documents: \(err)")
                } else {
                    self.searchedPeople = [UserModel]()
                    for document in querySnapshot!.documents {
                        if self.searchedPeople.count >= 5 {
                            break
                        }
                        let data = document.data()
                        self.searchedPeople.append(UserModel(
                            id: data["id"] as? String ?? "",
                            firstName: data["firstName"] as? String ?? "",
                            lastName: data["lastName"] as? String ?? "",
                            userName: data["userName"] as? String ?? "",
                            email: data["email"] as? String ?? "",
                            icon: data["icon"] as? String ?? "",
                            newNotifications: false
                        ))
                    }
                }
        }
    }
    
    func fetchUserData(userId: String) -> UserModel {
        print(userId)
        let docRef = db.collection("users").document(userId)
        var user = UserModel(
            id: "",
            firstName: "",
            lastName: "",
            userName: "",
            email: "",
            icon: "",
            newNotifications: false
        )
        docRef.getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let id = data?["id"] as? String ?? ""
                let firstName = data?["firstName"] as? String ?? ""
                let lastName = data?["lastName"] as? String ?? ""
                let userName = data?["userName"] as? String ?? ""
                let email = data?["email"] as? String ?? ""
                let icon = data?["icon"] as? String ?? ""
                user = UserModel(id: id, firstName: firstName, lastName: lastName, userName: userName, email: email, icon: icon, newNotifications: false)
                self.viewingUser = UserModel(id: id, firstName: firstName, lastName: lastName, userName: userName, email: email, icon: icon, newNotifications: false)

            } else {
                print("Document does not exist")
            }
        }
        return user
    }
    
    func fetchUserData() {
        userListener = db.collection("users").document(self.user?.uid ?? "")
            .addSnapshotListener { documentSnapshot, error in
              guard let document = documentSnapshot else {
                print("Error fetching document: \(error!)")
                return
              }
              guard let data = document.data() else {
                print("Document data was empty.")
                return
              }
                self.userData = UserModel(
                    id: data["id"] as? String ?? "",
                    firstName: data["firstName"] as? String ?? "",
                    lastName: data["lastName"] as? String ?? "",
                    userName: data["userName"] as? String ?? "",
                    email: data["email"] as? String ?? "",
                    icon: data["icon"] as? String ?? "",
                    newNotifications: data["newNotifications"] as? Bool ?? false
                )
                
            }
    }
    
    func createUser(firstName: String, lastName: String, userName: String, icon: String) {
        db.collection("users").document(self.user?.uid ?? "").setData([
            "id": self.user?.uid ?? "",
            "firstName": firstName,
            "lastName": lastName,
            "userName": userName,
            "email": self.user?.email ?? "",
            "icon": icon,
            "joined": Timestamp(date: Date())
   
        ]) { err in
            if let err = err {
                print("Error creating user: \(err)")
            } else {
                print("User successfully created!")
            }
        }
    }
    
    
    /*
     * Posts and Feeds related functions (like, comment, fetchFeed, etc)
     */
    
    func fetchLikesOnPost(post: PostModel) {
        db.collection("posts").document(post.id).collection("likes")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error fetching likes on post by \(post.authorUserName): \(err)")
                } else {
                    self.viewingLikes = [LikeModel]()
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        self.viewingLikes.append(LikeModel(
                            id: data["id"] as? String ?? "",
                            likerUserName: data["likerUserName"] as? String ?? "",
                            likerImg: data["likerImg"] as? String ?? "",
                            timestamp: data["timestamp"] as? Timestamp ?? Timestamp(date: Date())
                        ))
                    }
                    
                    self.viewingLikes.sort {
                        $0.timestamp.seconds > $1.timestamp.seconds
                    }
                    
                }
        }
    }
    
    func fetchCommentsOnPost(post: PostModel) {
        db.collection("posts").document(post.id).collection("comments")
            .getDocuments() { (querySnapshot, err) in
                if let err = err {
                    print("Error fetching comments on post by \(post.authorUserName): \(err)")
                } else {
                    self.viewingComments = [CommentModel]()
                    for document in querySnapshot!.documents {
                        let data = document.data()
                        self.viewingComments.append(CommentModel(
                            id: data["id"] as? String ?? "",
                            authorId: data["authorId"] as? String ?? "",
                            authorUserName: data["authorUserName"] as? String ?? "",
                            authorImg: data["authorImg"] as? String ?? "",
                            timestamp: data["timestamp"] as? Timestamp ?? Timestamp(date: Date()),
                            comment: data["comment"] as? String ?? ""
                        ))
                    }
                    
                    self.viewingComments.sort {
                        $0.timestamp.seconds > $1.timestamp.seconds
                    }
                }
        }
    }
    

    
    func commentOnPost(post: PostModel, comment: String) {
        db.collection("posts").document(post.id).updateData([
            "commentCount": FieldValue.increment(Int64(1)),
        ]) { err in
            if let err = err {
                print("Error incrementing comment count on post by \(post.authorUserName): \(err)")
            } else {
                print("Incremented comment count on post from \(post.authorUserName)!")
            }
        }
        let commentUid = UUID().uuidString
        let notificationId = UUID().uuidString

        db.collection("posts").document(post.id).collection("comments").document(commentUid).setData([
            "id": commentUid,
            "authorId": self.userData.id,
            "authorUserName": self.userData.userName,
            "authorImg": self.userData.icon,
            "timestamp": Timestamp(date: Date()),
            "comment": comment,
            "notificationId": notificationId
        ]) { err in
            if let err = err {
                print("Error adding to comment collection to post by \(post.authorUserName): \(err)")
            } else {
                print("Comment collection successfully added to for post by \(post.authorUserName)!")
            }
        }
        
        // notify user
        db.collection("users").document(post.authorId).collection("notifications").document(notificationId).setData([
            "id": notificationId,
            "notifierUserId": self.userData.id,
            "notifierUserName": self.userData.userName,
            "notifierImg": self.userData.icon,
            "message": "commented: \"\(comment)\" on your recent update!",
            "timestamp": Timestamp(date: Date())
        ]) { err in
            if let err = err {
                print("Error notifying \(post.authorUserName) about a comment: \(err)")
            } else {
                print("Successfully created a notification for \(post.authorUserName) about a comment by \(self.userData.id)!")
            }
        }
        
        // turn on notifications for post
        db.collection("users").document(post.authorId).updateData([
            "newNotifications": true
        ]) { err in
            if let err = err {
                print("Error flipping \(post.authorUserName)'s newNotifications to TRUE: \(err)")
            } else {
                print("Successfully flipped \(post.authorUserName)'s newNotifications to TRUE")
            }
        }
    }
    
    func deleteCommentOnPost(post: PostModel, comment: CommentModel) {
        db.collection("posts").document(post.id).updateData([
            "commentCount": FieldValue.increment(Int64(-1)),
        ]) { err in
            if let err = err {
                print("Error decrementing comment count on post by \(post.authorUserName): \(err)")
            } else {
                print("Decremented comment count on post from \(post.authorUserName)!")
            }
        }
        
        self.db.collection("posts").document(post.id).collection("comments").document(comment.id).getDocument() { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let notificationId = data?["notificationId"] as? String ?? ""
                self.db.collection("users").document(post.authorId).collection("notifications").document(notificationId).delete() { err in
                    if let err = err {
                        print("Error removing notification from \(post.authorUserName)'s inbox: \(err)")
                    } else {
                        print("Successfully removed notification from \(post.authorUserName)'s inbox!")
                        // delete like from collection
                        self.db.collection("posts").document(post.id).collection("comments").document(comment.id).delete() { err in
                            if let err = err {
                                print("Error deleting comment on post by \(post.authorUserName): \(err)")
                            } else {
                                print("Deleted comment on post from \(post.authorUserName)!")
                                self.fetchCommentsOnPost(post: post)
                            }
                        }
                    }
                }
            } else {
                print("Error removing notification from \(post.authorId)'s inbox, notification doesn't exist")
            }
        }
    }

    
    func likePost(post: PostModel) {
        // increment like on post
        let notificationId = UUID().uuidString
        db.collection("posts").document(post.id).updateData([
            "celebrateCount": FieldValue.increment(Int64(1)),
            "celebratorIds": FieldValue.arrayUnion([self.userData.id])
        ]) { err in
            if let err = err {
                print("Error incrementing like count on post by \(post.authorUserName): \(err)")
            } else {
                print("Incremented like count on post from \(post.authorUserName)!")
            }
        }
        
        // add user to collection of likes
        db.collection("posts").document(post.id).collection("likes").document(self.userData.id).setData([
            "id": self.userData.id,
            "likerUserName": self.userData.userName,
            "likerImg": self.userData.icon,
            "timestamp": Timestamp(date: Date()),
            "notificationId": notificationId
        ]) { err in
            if let err = err {
                print("Error adding to likes collection to post by \(post.authorUserName): \(err)")
            } else {
                print("Likes collection successfully added to for post by \(post.authorUserName)!")
            }
        }
        
        // notify user
        db.collection("users").document(post.authorId).collection("notifications").document(notificationId).setData([
            "id": notificationId,
            "notifierUserId": self.userData.id,
            "notifierUserName": self.userData.userName,
            "notifierImg": self.userData.icon,
            "message": "cheered your post!",
            "timestamp": Timestamp(date: Date())
        ]) { err in
            if let err = err {
                print("Error notifying \(post.authorUserName) with a like: \(err)")
            } else {
                print("Successfully created a notification for \(post.authorUserName) about a like by \(self.userData.id)!")
            }
        }
        
        // notify author of post
        db.collection("users").document(post.authorId).updateData([
            "newNotifications": true
        ]) { err in
            if let err = err {
                print("Error notifying \(post.authorUserName)'s newNotifications to TRUE: \(err)")
            } else {
                print("Successfully flipped \(post.authorUserName)'s newNotifications to TRUE")
            }
        }
        
    }
    
    func unLikePost(post: PostModel) {
        // decrement likes on post
        db.collection("posts").document(post.id).updateData([
            "celebrateCount": FieldValue.increment(Int64(-1)),
            "celebratorIds": FieldValue.arrayRemove([self.userData.id])
        ]) { err in
            if let err = err {
                print("Error decrementing like count and removing celebratorId on post by \(post.authorUserName): \(err)")
            } else {
                print("Decremented like count and removed celebratorId on post from \(post.authorUserName)!")
            }
        }
        
        // delete notification
        self.db.collection("posts").document(post.id).collection("likes").document(self.userData.id).getDocument() { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                let notificationId = data?["notificationId"] as? String ?? ""
                self.db.collection("users").document(post.authorId).collection("notifications").document(notificationId).delete() { err in
                    if let err = err {
                        print("Error removing notification from \(post.authorUserName)'s inbox: \(err)")
                    } else {
                        print("Successfully removed notification from \(post.authorUserName)'s inbox!")
                        // delete like from collection
                        self.db.collection("posts").document(post.id).collection("likes").document(self.userData.id).delete() { err in
                            if let err = err {
                                print("Error deleting from likes collection to post by \(post.authorUserName): \(err)")
                            } else {
                                print("Like successfully deleted from collection for post by \(post.authorUserName)!")
                            }
                        }
                    }
                }
            } else {
                print("Error removing notification from \(post.authorId)'s inbox, notification doesn't exist")
            }
        }
    }
    
    func fetchFeed() {
        self.feed = [PostModel]()
        feedListener = db.collection("posts").whereField("authorId", in: self.friendIds)
            .whereField("timestamp", isGreaterThanOrEqualTo: Timestamp(date: Date.yesterday))
            .order(by: "timestamp", descending: true)
//            .limit(to: 50)
            .addSnapshotListener { querySnapshot, error in
                    guard let documents = querySnapshot?.documents else {
                        print("Error fetching feed: \(error!)")
                        return
                    }
                DispatchQueue.main.async {
                    self.feed = documents.map { (doc) -> PostModel in
                        let data = doc.data()
                        let id = data["id"] as? String ?? ""
                        let authorId = data["authorId"] as? String ?? ""
                        let authorUserName = data["authorUserName"] as? String ?? ""
                        let authorImg = data["authorImg"] as? String ?? ""
                        let timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
                        let celebrateCount = data["celebrateCount"] as? Int ?? 0
                        let commentCount = data["commentCount"] as? Int ?? 0
                        let content = data["content"] as? String ?? ""
                        let celebratorIds = data["celebratorIds"] as? [String] ?? []
                        return PostModel(
                            id: id,
                            authorId: authorId,
                            authorUserName: authorUserName,
                            authorImg: authorImg,
                            timestamp: timestamp,
                            celebrateCount: celebrateCount,
                            commentCount: commentCount,
                            content: content,
                            celebratorIds: celebratorIds
                        )
                    }
                }
            }
    }
    
    func fetchFeed2() {
        self.feed = [PostModel]()
        for friend in self.friends {
            feedListener = db.collection("posts").whereField("authorId", isEqualTo: friend.id)
                    .addSnapshotListener { querySnapshot, error in
                            guard let documents = querySnapshot?.documents else {
                                print("Error fetching feed: \(error!)")
                                return
                            }
                        DispatchQueue.main.async {
                            for document in documents {
                                let data = document.data()
                                    if !self.feed.contains(where: {$0.id == data["id"] as? String ?? ""}) {
                                        self.feed.append(PostModel(
                                            id: data["id"] as? String ?? "",
                                            authorId: data["authorId"] as? String ?? "",
                                            authorUserName: data["authorUserName"] as? String ?? "",
                                            authorImg: data["authorImg"] as? String ?? "",
                                            timestamp: data["timestamp"] as? Timestamp ?? Timestamp(),
                                            celebrateCount: data["celebrateCount"] as? Int ?? 0,
                                            commentCount: data["commentCount"] as? Int ?? 0,
                                            content: data["content"] as? String ?? "",
                                            celebratorIds: data["celebratorIds"] as? [String] ?? []
                                        ))
                                    }

                                    else {
                                        self.feed.removeAll(where: {$0.id == data["id"] as? String ?? ""})

                                        self.feed.append(PostModel(
                                            id: data["id"] as? String ?? "",
                                            authorId: data["authorId"] as? String ?? "",
                                            authorUserName: data["authorUserName"] as? String ?? "",
                                            authorImg: data["authorImg"] as? String ?? "",
                                            timestamp: data["timestamp"] as? Timestamp ?? Timestamp(),
                                            celebrateCount: data["celebrateCount"] as? Int ?? 0,
                                            commentCount: data["commentCount"] as? Int ?? 0,
                                            content: data["content"] as? String ?? "",
                                            celebratorIds: data["celebratorIds"] as? [String] ?? []
                                        ))
                                    }
                            }
                            self.feed.sort {
                                $0.timestamp.seconds > $1.timestamp.seconds
                            }
                        }
                    }
        }
    }
    
    /*
     * Notifications related functions
     */
    
    func suppressNewNotifications() {
        db.collection("users").document(self.userData.id).updateData([
            "newNotifications": false
        ]) { err in
            if let err = err {
                print("Error suppressing new notifications \(err)")
            } else {
                print("Successfully suppressed new notifications")
            }
        }
    }
    
    func fetchNotifications() {
        notificationListener = db.collection("users").document(self.user?.uid ?? "").collection("notifications")
            .whereField("timestamp", isGreaterThanOrEqualTo: Timestamp(date: Date.yesterday))
            .addSnapshotListener { querySnapshot, error in
                    guard let documents = querySnapshot?.documents else {
                        print("Error fetching friend requests: \(error!)")
                        return
                    }
                DispatchQueue.main.async {
                    self.notifications = documents.map { (doc) -> NotificationModel in
                        let data = doc.data()
                        let id = data["id"] as? String ?? ""
                        let notifierUserId = data["notifierUserId"] as? String ?? ""
                        let notifierUserName = data["notifierUserName"] as? String ?? ""
                        let notifierImg = data["notifierImg"] as? String ?? ""
                        let message = data["message"] as? String ?? ""
                        let timestamp = data["timestamp"] as? Timestamp ?? Timestamp(date: Date())
                        return NotificationModel(
                            id: id,
                            notifierUserId: notifierUserId,
                            notifierUserName: notifierUserName,
                            notifierImg: notifierImg,
                            message: message,
                            timestamp: timestamp
                        )
                    }
                    
                    self.notifications.sort {
                        $0.timestamp.seconds > $1.timestamp.seconds
                    }
                }
            }
    }
    
    
    /*
     * Friend request related functions
     */
    
    func fetchFriendRequests() {
        friendRequestListener = db.collection("users").document(self.user?.uid ?? "").collection("friendRequests").whereField("id", isNotEqualTo: "")
            .addSnapshotListener { querySnapshot, error in
                    guard let documents = querySnapshot?.documents else {
                        print("Error fetching friend requests: \(error!)")
                        return
                    }
                DispatchQueue.main.async {
                    self.friendRequests = documents.map { (doc) -> UserModel in
                        let data = doc.data()
                        let id = data["id"] as? String ?? ""
                        let firstName = data["firstName"] as? String ?? ""
                        let lastName = data["lastName"] as? String ?? ""
                        let userName = data["userName"] as? String ?? ""
                        let email = data["email"] as? String ?? ""
                        let icon = data["icon"] as? String ?? ""
                        return UserModel(
                            id: id,
                            firstName: firstName,
                            lastName: lastName,
                            userName: userName,
                            email: email,
                            icon: icon,
                            newNotifications: false
                        )
                    }
                }
            }
        
        pendingFriendsListener = db.collection("users").document(self.user?.uid ?? "").collection("pendingFriendRequests").whereField("id", isNotEqualTo: "")
            .addSnapshotListener { querySnapshot, error in
                    guard let documents = querySnapshot?.documents else {
                        print("Error fetching pending friend requests: \(error!)")
                        return
                    }
                DispatchQueue.main.async {
                    self.sentRequests = documents.map { (doc) -> UserModel in
                        let data = doc.data()
                        let id = data["id"] as? String ?? ""
                        let firstName = data["firstName"] as? String ?? ""
                        let lastName = data["lastName"] as? String ?? ""
                        let userName = data["userName"] as? String ?? ""
                        let email = data["email"] as? String ?? ""
                        let icon = data["icon"] as? String ?? ""
                        return UserModel(
                            id: id,
                            firstName: firstName,
                            lastName: lastName,
                            userName: userName,
                            email: email,
                            icon: icon,
                            newNotifications: false
                        )
                    }
                }
            }
    }
    
    func sendFriendRequest(user: UserModel) {
        // add friend request to pending collection
        db.collection("users").document(self.userData.id).collection("pendingFriendRequests").document(user.id).setData([
            "id": user.id,
            "firstName": user.firstName,
            "lastName": user.lastName,
            "userName": user.userName,
            "email": user.email,
            "icon": user.icon
        ]) { err in
            if let err = err {
                print("Error adding friend request to pending collection: \(err)")
            } else {
                print("Friend request successfully added to pending collection!")
            }
        }
        // send friend request to user fr
        db.collection("users").document(user.id).collection("friendRequests").document(self.userData.id).setData([
            "id": self.userData.id,
            "firstName": self.userData.firstName,
            "lastName": self.userData.lastName,
            "userName": self.userData.userName,
            "email": self.userData.email,
            "icon": self.userData.icon
        ]) { err in
            if let err = err {
                print("Error sending friend request: \(err)")
            } else {
                print("Friend request successfully sent!")
            }
        }
    }
    
    func declineFriend(user: UserModel) {
        // remove friend request from self's friendRequest collection
        db.collection("users").document(self.userData.id).collection("friendRequests").document(user.id).delete() { err in
            if let err = err {
                print("Error declining friend request from \(user.id): \(err)")
            } else {
                print("Friend request from \(user.id) successfully declined and removed!")
            }
        }
        // remove pending request from user's pendingFriendRequests collection
        db.collection("users").document(user.id).collection("pendingFriendRequests").document(self.userData.id).delete() { err in
            if let err = err {
                print("Error remove pending request request from \(user.id): \(err)")
            } else {
                print("Pending request from \(self.userData.id) successfully declined and removed!")
            }
        }
    }
    
    func removeFriend(user: UserModel) {
        // me -> friend
        db.collection("users").document(self.userData.id).collection("friends").document(user.id).delete() { err in
            if let err = err {
                print("Error removing friend from self to friend: \(err)")
            } else {
                print("Person successfully removed from friends list (self to friend)!")
            }
        }
        
        // friend -> me
        db.collection("users").document(user.id).collection("friends").document(self.userData.id).delete() { err in
            if let err = err {
                print("Error removing friend from friend to self: \(err)")
            } else {
                print("Person successfully removed from friends list (friend to self)!")
            }
        }
    }
    
    func addFriend(user: UserModel) {
        // remove friend request
        db.collection("users").document(self.userData.id).collection("friendRequests").document(user.id).delete() { err in
            if let err = err {
                print("Error removing friend request from \(user.id): \(err)")
            } else {
                print("Friend request from \(user.id) successfully removed!")
            }
        }
        
        // remove pending request from user's pendingFriendRequests collection
        db.collection("users").document(user.id).collection("pendingFriendRequests").document(self.userData.id).delete() { err in
            if let err = err {
                print("Error remove pending request request from \(user.id): \(err)")
            } else {
                print("Pending request from \(self.userData.id) successfully removed!")
            }
        }
        
        // me -> friend
        db.collection("users").document(self.userData.id).collection("friends").document(user.id).setData([
            "id": user.id,
            "firstName": user.firstName,
            "lastName": user.lastName,
            "userName": user.userName,
            "email": user.email,
            "icon": user.icon
   
        ]) { err in
            if let err = err {
                print("Error adding friend from self to friend: \(err)")
            } else {
                print("Friend successfully added (self to friend)!")
            }
        }
        
        // friend -> me
        db.collection("users").document(user.id).collection("friends").document(self.userData.id).setData([
            "id": self.userData.id,
            "firstName": self.userData.firstName,
            "lastName": self.userData.lastName,
            "userName": self.userData.userName,
            "email": self.userData.email,
            "icon": self.userData.icon
   
        ]) { err in
            if let err = err {
                print("Error adding friend from friend to self: \(err)")
            } else {
                print("Friend successfully added (friend to self)!")
            }
        }
        
    }
    
    /*
     * Friend-related functions
     */
    
    func fetchFriendData(userId: String) {
        db.collection("users").document(userId).collection("friends").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.viewingFriends = [UserModel]()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    self.viewingFriends.append(UserModel(
                        id: data["id"] as? String ?? "",
                        firstName: data["firstName"] as? String ?? "",
                        lastName: data["lastName"] as? String ?? "",
                        userName: data["userName"] as? String ?? "",
                        email: data["email"] as? String ?? "",
                        icon: data["icon"] as? String ?? "",
                        newNotifications: data["newNotifications"] as? Bool ?? false
                    ))
                }
            }
        }
    }
    
    func fetchFriendData() {
        friendListener = db.collection("users").document(self.user?.uid ?? "").collection("friends").whereField("firstName", isNotEqualTo: "")
            .addSnapshotListener { querySnapshot, error in
                    guard let documents = querySnapshot?.documents else {
                        print("Error fetching friends: \(error!)")
                        return
                    }
                DispatchQueue.main.async {
                    self.friends = documents.map { (doc) -> UserModel in
                        let data = doc.data()
                        let id = data["id"] as? String ?? ""
                        let firstName = data["firstName"] as? String ?? ""
                        let lastName = data["lastName"] as? String ?? ""
                        let userName = data["userName"] as? String ?? ""
                        let email = data["email"] as? String ?? ""
                        let icon = data["icon"] as? String ?? ""
                        return UserModel(
                            id: id,
                            firstName: firstName,
                            lastName: lastName,
                            userName: userName,
                            email: email,
                            icon: icon,
                            newNotifications: false
                        )
                    }
                    self.friendIds = documents.map { (doc) -> String in
                        let data = doc.data()
                        let id = data["id"] as? String ?? ""
                        return id
                    }
                    self.friendIds.append(self.userData.id)
                    self.fetchFeed()
                }
                
            }
    }
    
    /*
     * ToDo-related functions
     */
    
    func fetchToDoData(userId: String) {
        db.collection("users").document(userId).collection("todos")
//        .whereField("isPrivate", isEqualTo: false)
        .whereField("completed", isEqualTo: false)
        .getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting todos: \(err)")
            } else {
                self.viewingTodos = [ToDoModel]()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    
                    self.viewingTodos.append(ToDoModel(
                        id: data["id"] as? String ?? "",
                        name: data["name"] as? String ?? "",
                        color: data["color"] as? Int ?? 0,
                        isPrivate: data["isPrivate"] as? Bool ?? false,
                        isFavorite: data["isFavorite"] as? Bool ?? false,
                        completed: data["completed"] as? Bool ?? false,
                        createdAt: data["createdAt"] as? Timestamp ?? Timestamp(date: Date()),
                        completedAt: data["completedAt"] as? Timestamp ?? Timestamp(date: Date())

                    ))
                }
                print("Successfully got todos from userId: \(userId)")
            }
        }
    }
    
    func fetchToDoData() {
        toDoListener = db.collection("users").document(self.user?.uid ?? "").collection("todos")
//            .whereField("id", isNotEqualTo: "")
            .order(by: "completedAt", descending: false)
            .addSnapshotListener { querySnapshot, error in
                    guard let documents = querySnapshot?.documents else {
                        print("Error fetching todos: \(error!)")
                        return
                    }
                DispatchQueue.main.async {
                    self.todos = documents.map { (doc) -> ToDoModel in
                        let data = doc.data()
                        let id = data["id"] as? String ?? ""
                        let name = data["name"] as? String ?? ""
                        let color = data["color"] as? Int ?? 0
                        let isFavorite = data["isFavorite"] as? Bool ?? false
                        let isPrivate = data["isPrivate"] as? Bool ?? false
                        let completed = data["completed"] as? Bool ?? false
                        let createdAt = data["createdAt"] as? Timestamp ?? Timestamp(date: Date())
                        let completedAt = data["completedAt"] as? Timestamp ?? Timestamp(date: Date())

                        
                        return ToDoModel(
                            id: id,
                            name: name,
                            color: color,
                            isPrivate: isPrivate,
                            isFavorite: isFavorite,
                            completed: completed,
                            createdAt: createdAt,
                            completedAt: completedAt
                        )
                            
                    }
                }

            }
    }
    
    func completeToDo(todo: ToDoModel) {
        db.collection("users").document(self.user?.uid ?? "").collection("todos").document(todo.id).updateData([
            "completed": true,
            "completedAt": Timestamp(date: Date())
        ]) { err in
            if let err = err {
                print("Error completing ToDo: \(err)")
            } else {
                print("ToDo successfully completed!")
            }
        }
    }
    
    func deleteToDo(todo: ToDoModel) {
        db.collection("users").document(self.user?.uid ?? "").collection("todos").document(todo.id).delete() { err in
            if let err = err {
                print("Error removing todo: \(err)")
            } else {
                print("todo successfully removed!")
            }
        }
    }
    
    func addToDo(todo: ToDoModel) {
        db.collection("users").document(self.user?.uid ?? "").collection("todos").document(todo.id).setData([
            "id": todo.id,
            "name": todo.name,
            "isFavorite": todo.isFavorite,
            "isPrivate": todo.isPrivate,
            "color": todo.color,
            "completed": todo.completed,
            "createdAt": todo.createdAt,
            "completedAt": todo.completedAt
        ]) { err in
            if let err = err {
                print("Error adding ToDo: \(err)")
            } else {
                print("ToDo successfully written!")
            }
        }
        
        if !todo.isPrivate {
            let postId: String = UUID().uuidString
            db.collection("posts").document(postId).setData([
                "id": postId,
                "authorId": self.userData.id,
                "authorUserName": self.userData.userName,
                "authorImg": self.userData.icon,
                "timestamp": Timestamp(date: Date()),
                "celebrateCount": 0,
                "commentCount": 0,
                "content": "started a to-do for \"\(todo.name)\"!"

            ]) { err in
                if let err = err {
                    print("Error creating ToDo post: \(err)")
                } else {
                    print("ToDo post successfully created!")
                }
            }
        }
    }
    
    /*
     * Task-related functions
     */
    
    func fetchTaskData() {
        taskListener = db.collection("users").document(self.user?.uid ?? "").collection("tasks").whereField("id", isNotEqualTo: "")
            .addSnapshotListener { querySnapshot, error in
                    guard let documents = querySnapshot?.documents else {
                        print("Error fetching tasks: \(error!)")
                        return
                    }
                DispatchQueue.main.async {
                    self.tasks = documents.map { (doc) -> TaskModel in
                        let data = doc.data()
                        let id = data["id"] as? String ?? ""
                        let name = data["name"] as? String ?? ""
                        let description = data["description"] as? String ?? ""
                        let img = data["img"] as? String ?? ""
                        let isFavorite = data["isFavorite"] as? Bool ?? false
                        let isPrivate = data["isPrivate"] as? Bool ?? false
                        let currentStreak = data["currentStreak"] as? Int ?? 0
                        let longestStreak = data["longestStreak"] as? Int ?? 0
                        let daysCompleted = data["daysCompleted"] as? [Timestamp] ?? []
                        let exactTimes = data["exactTimes"] as? [Timestamp] ?? []
                        let lastUpdated = data["lastUpdated"] as? Timestamp ?? Timestamp(date: Date())
                        let completedToday = data["completedToday"] as? Bool ?? false
                        
                        return TaskModel(
                            id: id,
                            name: name,
                            description: description,
                            img: img,
                            isFavorite: isFavorite,
                            isPrivate: isPrivate,
                            currentStreak: currentStreak,
                            longestStreak: longestStreak,
                            daysCompleted: daysCompleted,
                            exactTimes: exactTimes,
                            lastUpdated: lastUpdated,
                            completedToday: completedToday
                        )
                            
                    }
                }

            }
    }
    
    func fetchTaskData(userId: String) {
        db.collection("users").document(userId).collection("tasks").whereField("isPrivate", isEqualTo: false).getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                self.viewingTasks = [TaskModel]()
                for document in querySnapshot!.documents {
                    let data = document.data()
                    
                    self.viewingTasks.append(TaskModel(
                        id: data["id"] as? String ?? "",
                        name: data["name"] as? String ?? "",
                        description: data["description"] as? String ?? "",
                        img: data["img"] as? String ?? "",
                        isFavorite: data["isFavorite"] as? Bool ?? false,
                        isPrivate: data["isPrivate"] as? Bool ?? true,
                        currentStreak: data["currentStreak"] as? Int ?? 0,
                        longestStreak: data["longestStreak"] as? Int ?? 0,
                        daysCompleted: data["daysCompleted"] as? [Timestamp] ?? [],
                        exactTimes: data["exactTimes"] as? [Timestamp] ?? [],
                        lastUpdated: data["lastUpdated"] as? Timestamp ?? Timestamp(date: Date()),
                        completedToday: data["completedToday"] as? Bool ?? false    
                    ))
                }
                print("Successfully got tasks from userId: \(userId)")
            }
        }
    }
    
    func editStreak(task: TaskModel, newTitle: String, newDescription: String) {
        db.collection("users").document(self.user?.uid ?? "").collection("tasks").document(task.id).updateData([
            "name": newTitle,
            "description": newDescription,
            "lastUpdated": Timestamp(date: Date())
        ]) { err in
            if let err = err {
                print("Error editing streak: \(err)")
            } else {
                print("Streak successfully edited!")
            }
        }
    }
    
    func decrementStreak(task: TaskModel) {
        db.collection("users").document(self.user?.uid ?? "").collection("tasks").document(task.id).updateData([
            "isStreak": true,
            "currentStreak": FieldValue.increment(Int64(-1)),
            "longestStreak": task.longestStreak == task.currentStreak ? FieldValue.increment(Int64(-1)) : task.longestStreak,
            "daysCompleted": FieldValue.arrayRemove([task.daysCompleted.last!]),
            "exactTimes": FieldValue.arrayRemove([task.exactTimes.last!]),
            "lastUpdated": Timestamp(date: Date()),
            "completedToday": false
        ]) { err in
            if let err = err {
                print("Error decrementing streak: \(err)")
            } else {
                print("Streak successfully decremented!")
            }
        }
    }
    
    func incrementStreak(task: TaskModel) {
        // update task
        db.collection("users").document(self.user?.uid ?? "").collection("tasks").document(task.id).updateData([
            "isStreak": true,
            "currentStreak": FieldValue.increment(Int64(1)),
            "longestStreak": task.longestStreak <= task.currentStreak ? task.currentStreak + 1: task.longestStreak,
            "daysCompleted": FieldValue.arrayUnion([Timestamp(date: Date().noon)]),
            "exactTimes": FieldValue.arrayUnion([Timestamp(date: Date())]),
            "lastUpdated": Timestamp(date: Date()),
            "completedToday": true
        ]) { err in
            if let err = err {
                print("Error incrementing streak: \(err)")
            } else {
                print("Streak successfully incremented!")
            }
        }
        
        // create post
        if !task.isPrivate && !Calendar.current.isDate(Date(), inSameDayAs: Date(timeIntervalSince1970: TimeInterval(task.lastUpdated.seconds))) {
            let postId: String = UUID().uuidString
            db.collection("posts").document(postId).setData([
                "id": postId,
                "authorId": self.userData.id,
                "authorUserName": self.userData.userName,
                "authorImg": self.userData.icon,
                "timestamp": Timestamp(date: Date()),
                "celebrateCount": 0,
                "commentCount": 0,
                "content": "continued their \(task.currentStreak + 1) day \"\(task.name)\" streak!"

            ]) { err in
                if let err = err {
                    print("Error creating task post: \(err)")
                } else {
                    print("Task post successfully created!")
                }
            }
        }
    }
    
    func addTask(task: TaskModel) {
        db.collection("users").document(self.user?.uid ?? "").collection("tasks").document(task.id).setData([
            "id": task.id,
            "name": task.name,
            "description": task.description,
            "img": task.img,
            "isFavorite": task.isFavorite,
            "isPrivate": task.isPrivate,
            "currentStreak": task.currentStreak,
            "longestStreak": task.longestStreak,
            "daysCompleted": task.daysCompleted,
            "exactTimes": task.exactTimes,
            "lastUpdated": task.lastUpdated,
            "completedToday": false
        ]) { err in
            if let err = err {
                print("Error adding task: \(err)")
            } else {
                print("Task successfully written!")
            }
        }
        
        if !task.isPrivate {
            let postId: String = UUID().uuidString
            db.collection("posts").document(postId).setData([
                "id": postId,
                "authorId": self.userData.id,
                "authorUserName": self.userData.userName,
                "authorImg": self.userData.icon,
                "timestamp": Timestamp(date: Date()),
                "celebrateCount": 0,
                "commentCount": 0,
                "content": "started a streak for \"\(task.name)\"!"

            ]) { err in
                if let err = err {
                    print("Error creating task post: \(err)")
                } else {
                    print("Task post successfully created!")
                }
            }
        }

    }

    
    func deleteTask(task: TaskModel) {
        db.collection("users").document(self.user?.uid ?? "").collection("tasks").document(task.id).delete() { err in
            if let err = err {
                print("Error removing task: \(err)")
            } else {
                print("Task successfully removed!")
            }
        }
    }
    
    /*
     * Auth-related functions
     */
    
    func listenToAuthState() {
        Auth.auth().addStateDidChangeListener { [weak self] _, user in
            guard let self = self else {
                return
            }
            self.user = user
            
        }
    }
    
    func signIn(email: String, password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            if let error = error {
                print("Sign in error: \(error.localizedDescription)")
                self?.signInError = true
                return
            }
            guard let strongSelf = self else { return }
            self?.signInError = false
        }
    }
    
    func signUp(email: String, password: String, firstName: String, lastName: String, userName: String, icon: String) {
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                self.signUpError = true
                print("an error occured: \(error.localizedDescription)")
                return
            }
            self.signUpError = false
            self.createUser(firstName: firstName, lastName: lastName, userName: userName, icon: icon)
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
            self.tasks = [TaskModel]()
            self.friends = [UserModel]()
            self.friendIds = [String]()
            self.sentRequests = [UserModel]()
            self.friendRequests = [UserModel]()
            self.viewingFriends = [UserModel]()
            self.viewingTasks = [TaskModel]()
            self.searchedPeople = [UserModel]()
            self.viewingComments = [CommentModel]()
            self.viewingLikes = [LikeModel]()
            self.feed = [PostModel]()
            self.notifications = [NotificationModel]()
            self.viewingUser = UserModel(
                id: "",
                firstName: "",
                lastName: "",
                userName: "",
                email: "",
                icon: "",
                newNotifications: false
            )
            self.userData = UserModel(
                id: "",
                firstName: "",
                lastName: "",
                userName: "",
                email: "",
                icon: "",
                newNotifications: false
            )
            userListener?.remove()
            taskListener?.remove()
            friendListener?.remove()
            friendRequestListener?.remove()
            pendingFriendsListener?.remove()
            feedListener?.remove()
            notificationListener?.remove()
            
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

extension Date {
    static var yesterday: Date { return Date().dayBefore }
    static var tomorrow:  Date { return Date().dayAfter }
    var dayBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -1, to: noon)!
    }
    var twoDaysBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -2, to: noon)!
    }
    var threeDaysBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -3, to: noon)!
    }
    var fourDaysBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -4, to: noon)!
    }
    var fiveDaysBefore: Date {
        return Calendar.current.date(byAdding: .day, value: -5, to: noon)!
    }
    var dayAfter: Date {
        return Calendar.current.date(byAdding: .day, value: 1, to: noon)!
    }
    var noon: Date {
        return Calendar.current.date(bySettingHour: 12, minute: 0, second: 0, of: self)!
    }
    var month: Int {
        return Calendar.current.component(.month,  from: self)
    }
    var isLastDayOfMonth: Bool {
        return dayAfter.month != month
    }
    
    func timeAgoDisplay() -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: self, relativeTo: Date())
    }
    
    func getFormattedDate(format: String) -> String {
        let dateformat = DateFormatter()
        dateformat.dateFormat = format
        return dateformat.string(from: self)
    }
    
    func getAllDates() -> [Date] {
        let calendar = Calendar.current
        
        let startDate = calendar.date(from: Calendar.current.dateComponents([.year, .month], from: self))!
        
        let range = calendar.range(of: .day, in: .month, for: startDate)!
        return range.compactMap { day -> Date in
            return calendar.date(byAdding: .day, value: day - 1, to: startDate)!
        }
        
    }
}

extension View {
    func placeholder<Content: View>(
        when shouldShow: Bool,
        alignment: Alignment = .leading,
        @ViewBuilder placeholder: () -> Content) -> some View {

        ZStack(alignment: alignment) {
            placeholder().opacity(shouldShow ? 0.5 : 0)
            self
        }
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
