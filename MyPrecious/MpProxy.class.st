Class {
	#name : #MpProxy,
	#superclass : #ProtoObject,
	#instVars : [
		'channel',
		'remoteReference',
		'isDebugging'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #'instance creation' }
MpProxy class >> channel: aChannel remoteReference: aRemoteReference [
	^ self new
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
	isDebugging ifTrue: [^super class]. "Make it possible to debug + avoid infinite debuggers"
	message := Message selector: #class.
	^ self doesNotUnderstand: message
]

{ #category : #'reflective operations' }
MpProxy >> doesNotUnderstand: aMessage [
	| result |
	result := [channel sendMessageSynchronously: aMessage to: self] 
		on: Error do: [: ex | 
			isDebugging := true.
			ex pass].
	isDebugging := false.
	^result
]

{ #category : #'initialize-release' }
MpProxy >> initialize [
	super initialize.
	isDebugging := false.
]

{ #category : #marshalling }
MpProxy >> marshalWith: marshaller [
	^marshaller marshalRemoteReference: remoteReference
]

{ #category : #accessing }
MpProxy >> yourself [
	^self
]
