Class {
	#name : #MpProxy,
	#superclass : #Object,
	#instVars : [
		'channel',
		'remoteReference'
	],
	#category : #'MyPrecious-Kernel'
}

{ #category : #'instance creation' }
MpProxy class >> channel: aChannel remoteReference: aRemoteReference [
	^ self new
		channel: aChannel remoteReference: aRemoteReference;
		yourself
]

{ #category : #'class membership' }
MpProxy >> actualClass [
	^super class
]

{ #category : #'initialize-release' }
MpProxy >> channel: aChannel remoteReference: aRemoteReference [
	remoteReference := aRemoteReference. 
	channel := aChannel.
]

{ #category : #'class membership' }
MpProxy >> class [
	^self sendViaChannelSelector: #class
]

{ #category : #'reflective operations' }
MpProxy >> doesNotUnderstand: aMessage [
	^ self sendViaChannelMessage: aMessage
]

{ #category : #marshalling }
MpProxy >> marshalWith: marshaller [
	^marshaller marshalRemoteReference: remoteReference
]

{ #category : #'reflective operations' }
MpProxy >> sendViaChannelMessage: aMessage [
	^ channel send: aMessage to: self
]

{ #category : #'reflective operations' }
MpProxy >> sendViaChannelSelector: selector [
	| message |
	message := Message selector: selector.
	^ self sendViaChannelMessage: message
]

{ #category : #evaluating }
MpProxy >> value [
	^self sendViaChannelSelector: #value
]
