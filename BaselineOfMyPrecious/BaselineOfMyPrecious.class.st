Class {
	#name : #BaselineOfMyPrecious,
	#superclass : #BaselineOf,
	#category : #BaselineOfMyPrecious
}

{ #category : #baselines }
BaselineOfMyPrecious >> baseline: spec [
	<baseline>

	spec for: #'common' do: [
		spec 
			baseline: 'Equals' with: [
				spec
					repository: 'github://bouraqadi/PharoMisc' ];
			baseline: 'Concurrency' with: [
				spec
					repository: 'github://bouraqadi/PharoMisc' ];
			baseline: 'NetworkExtras' with: [
				spec
					repository: 'github://bouraqadi/PharoMisc' ].

		spec 
			repository: 'github://bouraqadi/MyPrecious';
			package: #MyPrecious with: [
				spec requires: #('Equals' 'Concurrency')];
			package: #MyPreciousTests with: [
				spec requires: #('MyPrecious')];
			package: #MyPreciousNet with: [
				spec requires: #('MyPrecious' 'NetworkExtras')];
			package: #MyPreciousNetTests with: [
				spec requires: #('MyPreciousTests' 'MyPreciousNet')].
			
		spec
				group: 'kernel' with: #('MyPrecious');
				group: 'net' with: #('kernel' 'MyPreciousNet');
				group: 'default' with: #('net' 'MyPreciousTests' 'MyPreciousNetTests')
	].

]
