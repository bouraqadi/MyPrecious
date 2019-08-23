Class {
	#name : #MpProxy,
	#superclass : #ProtoObject,
	#instVars : [
		'channel',
		'remoteReference'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #'instance creation' }
MpProxy class >> channel: aChannel remoteReference: aRemoteReference [
	^ self basicNew
		channel: aChannel remoteReference: aRemoteReference;
		yourself
]

{ #category : #'initialize-release' }
MpProxy >> channel: aChannel remoteReference: aRemoteReference [
	remoteReference := aRemoteReference. 
	channel := aChannel.
]

{ #category : #'class membership' }
MpProxy >> class [
	| message |
	message := Message selector: #class.
	^ self doesNotUnderstand: message
]

{ #category : #'reflective operations' }
MpProxy >> doesNotUnderstand: aMessage [
	^ channel send: aMessage to: self
]

{ #category : #marshalling }
MpProxy >> marshalWith: marshaller [
	^marshaller marshalRemoteReference: remoteReference
]

{ #category : #accessing }
MpProxy >> yourself [
	^self
]
