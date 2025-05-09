import 'dart:async';
import 'dart:io';

import 'package:ecar_mobile/models/Route/route.dart' as Model;
import 'package:ecar_mobile/providers/route_provider.dart';
import 'package:ecar_mobile/screens/drives_screen.dart';
import 'package:ecar_mobile/utils/alert_helpers.dart';
import 'package:ecar_mobile/utils/NavigationUtils/button_helper.dart';
import 'package:ecar_mobile/utils/NavigationUtils/example_switch.dart';
import 'package:ecar_mobile/utils/NavigationUtils/remaining_time_distance.dart';
import 'package:ecar_mobile/utils/scaffold_helpers.dart';
import 'package:flutter/material.dart';
import 'package:google_navigation_flutter/google_navigation_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ecar_mobile/utils/NavigationUtils/navigation_page_widget.dart';
import 'package:provider/provider.dart';

class DrivesNavigationScreen extends ExamplePage {
  Model.Route? object;
  DrivesNavigationScreen({super.key, this.object})
      : super(leading:const Icon(Icons.navigation), title: 'Navigation');

  @override
  ExamplePageState<DrivesNavigationScreen> createState() =>
      _DrivesNavigationScreenState();
}

//screen for driver's navigation towards source and destination point
class _DrivesNavigationScreenState
    extends ExamplePageState<DrivesNavigationScreen> {
//delay to make sure that routes are clear
  static const int _disableNavigationUIDelay = 500;

  static const LatLng cameraLocation =
      LatLng(latitude: 44.0571, longitude: 17.4501);
  static const int _userLocationTimeoutMS = 1500;

  /// speed multiplier used for simulation.
  static const double simulationSpeedMultiplier = 5;

  GoogleNavigationViewController? _navigationViewController;

//last user location recieved from navigation
  LatLng? _userLocation;

//variables required for navigation handling
  int _remainingTime = 0;
  int _remainingDistance = 0;
  int _onRouteChangedEventCallCount = 0;
  int _onRoadSnappedLocationUpdatedEventCallCount = 0;
  int _onRoadSnappedRawLocationUpdatedEventCallCount = 0;
  int _onTrafficUpdatedEventCallCount = 0;
  int _onReroutingEventCallCount = 0;
  int _onGpsAvailabilityEventCallCount = 0;
  int _onArrivalEventCallCount = 0;
  int _onSpeedingUpdatedEventCallCount = 0;
  int _onRecenterButtonClickedEventCallCount = 0;
  int _onRemainingTimeOrDistanceChangedEventCallCount = 0;
  int _onNavigationUIEnabledChangedEventCallCount = 0;

  bool _navigationHeaderEnabled = true;
  bool _navigationFooterEnabled = true;
  bool _navigationUIEnabled = true;
  bool _recenterButtonEnabled = true;

  bool _termsAndConditionsAccepted = false;
  bool _locationPermissionsAccepted = false;

  bool _isAutoScreenAvailable = false;

  bool _validRoute = false;
  bool _errorOnSetDestinations = false;
  bool _navigatorInitialized = false;
  bool _guidanceRunning = false;
  bool _showRemainingTimeAndDistanceLabels = true;

//update finish API method call allowing
  bool _useFinsihAPI = true;

  NavigationTravelMode _travelMode = NavigationTravelMode.driving;

//shows if navigatior is initalized at all
  bool _navigatorInitializedAtLeastOnce = false;

  /// event subscriptions need to be stored to be able to cancel them.
  StreamSubscription<OnArrivalEvent>? _onArrivalSubscription;
  StreamSubscription<void>? _onReRoutingSubscription;
  StreamSubscription<void>? _onGpsAvailabilitySubscription;
  StreamSubscription<void>? _trafficUpdatedSubscription;
  StreamSubscription<void>? _onRouteChangedSubscription;
  StreamSubscription<RemainingTimeOrDistanceChangedEvent>?
      _remainingTimeOrDistanceChangedSubscription;
  StreamSubscription<RoadSnappedLocationUpdatedEvent>?
      _roadSnappedLocationUpdatedSubscription;
  StreamSubscription<RoadSnappedRawLocationUpdatedEvent>?
      _roadSnappedRawLocationUpdatedSubscription;

//waypoints declaration
  final List<NavigationWaypoint> _waypoints = <NavigationWaypoint>[];

  Marker? _newWaypointMarker;
  final List<Marker> _destinationWaypointMarkers = <Marker>[];

  int _nextWaypointIndex = 0;

  EdgeInsets _mapPadding = const EdgeInsets.all(0);

  late RouteProvider routeProvider;
  Model.Route? route;

  bool _sourcePointEnabled = true;
  bool _destinationPointEnabled = true;

  bool _navigationSessionInitialized = false;
  bool _locationPermitted = false;
  bool _notificationsPermitted = false;

  @override
  void initState() {
    super.initState();
    routeProvider = context.read<RouteProvider>();
    unawaited(_initialize());
    debugPrint("Test lat long: ${widget?.object?.sourcePoint?.latitude}");
  }

  @override
  void dispose() {
    _clearListeners();
    GoogleMapsNavigator.cleanup();
    clearRegisteredImages();
    super.dispose();
  }

  Future<void> _initialize() async {
    // check if terms and conditions have been accepted and show dialog if not.
    await _showTermsAndConditionsDialogIfNeeded();

    // check if location permissions have been accepted and show dialog if not.
    await _askLocationPermissionsIfNeeded();

    // initilize navigator if terms and conditions and location permissions
    if (_termsAndConditionsAccepted && _locationPermissionsAccepted) {
      await _initializeNavigator();
    }
  }

  Future<void> _initializeNavigator() async {
    assert(_termsAndConditionsAccepted, 'Terms must be accepted');
    assert(
        _locationPermissionsAccepted, 'Location permissions must be granted');

    if (!_navigatorInitialized) {
      debugPrint('Initializing new navigation session...');
      await GoogleMapsNavigator.initializeNavigationSession();
      await _setupListeners();
      await _updateNavigatorInitializationState();
      await _restorePossibleNavigatorState();
      unawaited(_setDefaultUserLocationAfterDelay());
      debugPrint('Navigator has been initialized: $_navigatorInitialized');
    }
    setState(() {});
  }

//terms and conditions dialog
  Future<void> _showTermsAndConditionsDialogIfNeeded() async {
    _termsAndConditionsAccepted = await requestTermsAndConditionsAcceptance();
    setState(() {});
  }

  Future<bool> requestTermsAndConditionsAcceptance() async {
    return (await GoogleMapsNavigator.areTermsAccepted()) ||
        (await GoogleMapsNavigator.showTermsAndConditionsDialog(
          'Tearms and conditions',
          'eCar',
        ));
  }

//loc permission
  Future<void> _askLocationPermissionsIfNeeded() async {
    _locationPermissionsAccepted = await requestLocationDialogAcceptance();
    setState(() {});
  }

  Future<bool> requestLocationDialogAcceptance() async {
    return (await Permission.locationWhenInUse.isGranted) ||
        (await Permission.locationWhenInUse.request()) ==
            PermissionStatus.granted;
  }

//setting and cleaning up listeners
  Future<void> _setupListeners() async {
    // clear old listeners to make sure we subscribe to each event only once.
    _clearListeners();

    _onArrivalSubscription =
        GoogleMapsNavigator.setOnArrivalListener(_onArrivalEvent);
    _onReRoutingSubscription =
        GoogleMapsNavigator.setOnReroutingListener(_onReroutingEvent);
    _onGpsAvailabilitySubscription =
        await GoogleMapsNavigator.setOnGpsAvailabilityListener(
            _onGpsAvailabilityEvent);
    _trafficUpdatedSubscription =
        GoogleMapsNavigator.setTrafficUpdatedListener(_onTrafficUpdatedEvent);
    _onRouteChangedSubscription =
        GoogleMapsNavigator.setOnRouteChangedListener(_onRouteChangedEvent);
    _remainingTimeOrDistanceChangedSubscription =
        GoogleMapsNavigator.setOnRemainingTimeOrDistanceChangedListener(
            _onRemainingTimeOrDistanceChangedEvent,
            remainingTimeThresholdSeconds: 60,
            remainingDistanceThresholdMeters: 100);
    _roadSnappedLocationUpdatedSubscription =
        await GoogleMapsNavigator.setRoadSnappedLocationUpdatedListener(
            _onRoadSnappedLocationUpdatedEvent);
    _roadSnappedRawLocationUpdatedSubscription =
        await GoogleMapsNavigator.setRoadSnappedRawLocationUpdatedListener(
            _onRoadSnappedRawLocationUpdatedEvent);
  }

  void _onRoadSnappedLocationUpdatedEvent(
      RoadSnappedLocationUpdatedEvent event) {
    if (!mounted) {
      return;
    }

    setState(() {
      _userLocation = event.location;
      _onRoadSnappedLocationUpdatedEventCallCount += 1;
    });
  }

  void _onRoadSnappedRawLocationUpdatedEvent(
      RoadSnappedRawLocationUpdatedEvent event) {
    if (!mounted) {
      return;
    }

    setState(() {
      _userLocation = event.location;
      _onRoadSnappedRawLocationUpdatedEventCallCount += 1;
    });
  }

  void _onRemainingTimeOrDistanceChangedEvent(
      RemainingTimeOrDistanceChangedEvent event) {
    if (!mounted) {
      return;
    }
    setState(() {
      _remainingDistance = event.remainingDistance.toInt();
      _remainingTime = event.remainingTime.toInt();
      _onRemainingTimeOrDistanceChangedEventCallCount += 1;
    });
  }

  void _onRouteChangedEvent() {
    if (!mounted) {
      return;
    }
    setState(() {
      _onRouteChangedEventCallCount += 1;
    });
  }

  void _onTrafficUpdatedEvent() {
    setState(() {
      _onTrafficUpdatedEventCallCount += 1;
    });
  }

  void _onReroutingEvent() {
    setState(() {
      _onReroutingEventCallCount += 1;
    });
  }

  void _onGpsAvailabilityEvent(GpsAvailabilityUpdatedEvent event) {
    setState(() {
      _onGpsAvailabilityEventCallCount += 1;
    });
  }

  void _onArrivalEvent(
    OnArrivalEvent event,
  ) {
    if (!mounted) {
      return;
    }
    _arrivedToWaypoint(event.waypoint);
    setState(() {
      _onArrivalEventCallCount += 1;
    });
  }

  void _clearListeners() {
    _onArrivalSubscription?.cancel();
    _onArrivalSubscription = null;

    _onReRoutingSubscription?.cancel();
    _onReRoutingSubscription = null;

    _onGpsAvailabilitySubscription?.cancel();
    _onGpsAvailabilitySubscription = null;

    _trafficUpdatedSubscription?.cancel();
    _trafficUpdatedSubscription = null;

    _onRouteChangedSubscription?.cancel();
    _onRouteChangedSubscription = null;

    _remainingTimeOrDistanceChangedSubscription?.cancel();
    _remainingTimeOrDistanceChangedSubscription = null;

    _roadSnappedLocationUpdatedSubscription?.cancel();
    _roadSnappedLocationUpdatedSubscription = null;

    _roadSnappedRawLocationUpdatedSubscription?.cancel();
    _roadSnappedRawLocationUpdatedSubscription = null;
  }

  Future<void> _updateNavigatorInitializationState() async {
    _navigatorInitialized = await GoogleMapsNavigator.isInitialized();
    if (_navigatorInitialized) {
      _navigatorInitializedAtLeastOnce = true;
    }
    setState(() {});
  }

  Future<void> _updateTermsAcceptedState() async {
    _termsAndConditionsAccepted = await GoogleMapsNavigator.areTermsAccepted();
    setState(() {});
  }

  Future<void> _restorePossibleNavigatorState() async {
    if (_navigatorInitialized) {
      final List<NavigationWaypoint> waypoints = await _getWaypoints();

      // Restore local waypoint index
      if (waypoints.isNotEmpty) {
        final List<String> parts = waypoints.last.title.split(' ');
        if (parts.length == 2) {
          _nextWaypointIndex = int.tryParse(parts.last) ?? 0;
        }

        _validRoute = true;
        _waypoints.clear();
        _waypoints.addAll(waypoints);
      }

      setState(() {});
    }
  }

  // helper function to update local waypoint data from the navigation session.
  Future<List<NavigationWaypoint>> _getWaypoints() async {
    assert(_navigatorInitialized);
    final List<RouteSegment> routeSegments =
        await GoogleMapsNavigator.getRouteSegments();
    return routeSegments
        .where((RouteSegment e) => e.destinationWaypoint != null)
        .map((RouteSegment e) => e.destinationWaypoint!)
        .toList();
  }

  Future<void> _arrivedToWaypoint(NavigationWaypoint waypoint) async {
    debugPrint('Arrived to waypoint: ${waypoint.title}');

    // remove the first waypoint from the list.
    if (_waypoints.isNotEmpty) {
      _waypoints.removeAt(0);
    }
    // remove the first destination marker from the list.
    if (_destinationWaypointMarkers.isNotEmpty) {
      final Marker markerToRemove = _destinationWaypointMarkers.first;
      await _navigationViewController!.removeMarkers(<Marker>[markerToRemove]);

      await unregisterImage(markerToRemove.options.icon);

      _destinationWaypointMarkers.removeAt(0);
    }

    await GoogleMapsNavigator.continueToNextDestination();

    if (_waypoints.isEmpty) {
      debugPrint('Arrived to last waypoint, stopping navigation.');

      // if there is no next waypoint, it means we have arrived at the last
      // destination. Hence, stop navigation.
      await _stopGuidedNavigation();
    }

    setState(() {});
  }

  Future<void> _clearNavigationWaypoints() async {
    // stopping guided navigation will also clear the waypoints.
    _useFinsihAPI = false;
    await _stopGuidedNavigation();
    setState(() {
      _waypoints.clear();
      _sourcePointEnabled = true;
      _destinationPointEnabled = true;
    });
  }

  Future<void> _setDefaultUserLocationAfterDelay() async {
    Future<void>.delayed(const Duration(milliseconds: _userLocationTimeoutMS),
        () async {
      if (mounted && _userLocation == null) {
        _userLocation =
            await _navigationViewController?.getMyLocation() ?? cameraLocation;
        if (mounted) {
          setState(() {});
        }
      }
    });
  }

  Future<void> _getInitialViewStates() async {
    assert(_navigationViewController != null);
    if (_navigationViewController != null) {
      final bool navigationHeaderEnabled =
          await _navigationViewController!.isNavigationHeaderEnabled();
      final bool navigationFooterEnabled =
          await _navigationViewController!.isNavigationFooterEnabled();

      final bool navigationUIEnabled =
          await _navigationViewController!.isNavigationUIEnabled();
      final bool recenterButtonEnabled =
          await _navigationViewController!.isRecenterButtonEnabled();

      setState(() {
        _navigationHeaderEnabled = navigationHeaderEnabled;
        _navigationFooterEnabled = navigationFooterEnabled;
        _navigationUIEnabled = navigationUIEnabled;
        _recenterButtonEnabled = recenterButtonEnabled;
      });
    }
  }

  void _onRecenterButtonClickedEvent(
      NavigationViewRecenterButtonClickedEvent msg) {
    setState(() {
      _onRecenterButtonClickedEventCallCount += 1;
    });
  }

  void _onNavigationUIEnabledChanged(bool enabled) {
    if (mounted) {
      setState(() {
        _navigationUIEnabled = enabled;
        _onNavigationUIEnabledChangedEventCallCount += 1;
      });
    }
  }

  Future<void> _startGuidedNavigation() async {
    assert(_navigationViewController != null);
    if (!_navigatorInitialized) {
      await _initializeNavigator();
    }
    await _navigationViewController?.setNavigationUIEnabled(true);
    await _startGuidance();
    await _navigationViewController?.followMyLocation(CameraPerspective.tilted);
    await _updateAPIStart();
    setState(() {
      _useFinsihAPI = true;
    });
  }

  Future<void> _updateAPIStart() async {
    var request = {};
    await routeProvider.update(widget?.object?.id, request);
    debugPrint("Route ${widget?.object?.id} has been started...");
  }

  Future<void> _stopGuidedNavigation() async {
    assert(_navigationViewController != null);

    await GoogleMapsNavigator.cleanup();
    await _removeNewWaypointMarker();
    await _removeDestinationWaypointMarkers();
    _waypoints.clear();

    // Reset navigation perspective to top down north up.
    await _navigationViewController!
        .followMyLocation(CameraPerspective.topDownNorthUp);

    if (_useFinsihAPI) {
      await _updateFinishAPI();
    }

    // Disable navigation UI after small delay to make sure routes are cleared.
    // On Android routes are not always created on the map, if navigation UI is
    // disabled right after cleanup.
    unawaited(Future<void>.delayed(
        const Duration(milliseconds: _disableNavigationUIDelay), () async {
      await _navigationViewController!.setNavigationUIEnabled(false);
    }));

    // Make sure that navigation initialization state is up-to-date.
    await _updateNavigatorInitializationState();

    // On navigator cleanup simulation is stopped as well, update the state.
    setState(() {
      _validRoute = false;
      _guidanceRunning = false;
      _nextWaypointIndex = 0;
      _remainingDistance = 0;
      _remainingTime = 0;
    });
  }

  Future<void> _updateFinishAPI() async {
    route = await routeProvider.updateFinish(widget?.object?.id);
    debugPrint("Route ${widget?.object?.id} has been finished...");
  }

  MarkerOptions _buildNewWaypointMarkerOptions(LatLng target) {
    return MarkerOptions(
        infoWindow: const InfoWindow(title: 'Destination'),
        position:
            LatLng(latitude: target.latitude, longitude: target.longitude));
  }

  Future<void> _updateNewWaypointMarker(LatLng target) async {
    final MarkerOptions markerOptions = _buildNewWaypointMarkerOptions(target);
    if (_newWaypointMarker == null) {
      // Add new marker.
      final List<Marker?> addedMarkers = await _navigationViewController!
          .addMarkers(<MarkerOptions>[markerOptions]);
      if (addedMarkers.first != null) {
        _newWaypointMarker = addedMarkers.first;
      } else {
        ScaffoldHelpers.showScaffold(
            context, 'Error while adding destination marker');
      }
    } else {
      // Update existing marker.
      final Marker updatedWaypointMarker =
          _newWaypointMarker!.copyWith(options: markerOptions);
      final List<Marker?> updatedMarkers = await _navigationViewController!
          .updateMarkers(<Marker>[updatedWaypointMarker]);
      if (updatedMarkers.first != null) {
        _newWaypointMarker = updatedMarkers.first;
      } else {
        ScaffoldHelpers.showScaffold(
            context, 'Error while updating destination marker');
      }
    }
    setState(() {});
  }

  Future<void> _removeNewWaypointMarker() async {
    if (_newWaypointMarker != null) {
      await _navigationViewController!
          .removeMarkers(<Marker>[_newWaypointMarker!]);
      _newWaypointMarker = null;
      setState(() {});
    }
  }

  Future<void> _removeDestinationWaypointMarkers() async {
    if (_destinationWaypointMarkers.isNotEmpty) {
      await _navigationViewController!
          .removeMarkers(_destinationWaypointMarkers);
      _destinationWaypointMarkers.clear();

      // Unregister custom marker images
      await clearRegisteredImages();
      setState(() {});
    }
  }

  Future<void> showCalculatingRouteMessage() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    if (!_validRoute) {
      ScaffoldHelpers.showScaffold(context, 'Calculating the route.');
    }
  }

//adding source point provided by user
  Future<void> _addSourcePoint() async {
    LatLng location = LatLng(
        latitude: widget?.object?.sourcePoint?.latitude ?? 0.0,
        longitude: widget?.object?.sourcePoint?.longitude ?? 0.0);
    await _updateNewWaypointMarker(location);
    if (_newWaypointMarker != null) {
      setState(() {
        _validRoute = false;
      });
      _nextWaypointIndex += 1;
      _waypoints.add(NavigationWaypoint.withLatLngTarget(
        title: 'Waypoint $_nextWaypointIndex',
        target: LatLng(
          latitude: _newWaypointMarker!.options.position.latitude,
          longitude: _newWaypointMarker!.options.position.longitude,
        ),
      ));

      //convert new waypoint marker to destination marker.
      await _convertNewWaypointMarkerToDestinationMarker(_nextWaypointIndex);
      await _updateNavigationDestinationsAndNavigationViewState();
    }
    setState(() {
      _sourcePointEnabled = false;
    });
  }

//adding destination point provided by user
  Future<void> _addDestinationPoint() async {
    LatLng location = LatLng(
        latitude: widget?.object?.destinationPoint?.latitude ?? 0.0,
        longitude: widget?.object?.destinationPoint?.longitude ?? 0.0);
    await _updateNewWaypointMarker(location);
    if (_newWaypointMarker != null) {
      setState(() {
        _validRoute = false;
      });
      _nextWaypointIndex += 1;
      _waypoints.add(NavigationWaypoint.withLatLngTarget(
        title: 'Waypoint $_nextWaypointIndex',
        target: LatLng(
          latitude: _newWaypointMarker!.options.position.latitude,
          longitude: _newWaypointMarker!.options.position.longitude,
        ),
      ));

      //convert new waypoint marker to destination marker.
      await _convertNewWaypointMarkerToDestinationMarker(_nextWaypointIndex);
      await _updateNavigationDestinationsAndNavigationViewState();
    }
    setState(() {
      _destinationPointEnabled = false;
    });
  }

  /// helper method that first updates destinations and then
  /// updates navigation view state to show the route overview.
  Future<void> _updateNavigationDestinationsAndNavigationViewState() async {
    final bool success = await _updateNavigationDestinations();
    if (success) {
      await _navigationViewController!.setNavigationUIEnabled(true);

      if (!_guidanceRunning) {
        await _navigationViewController!.showRouteOverview();
      }
      setState(() {
        _validRoute = true;
      });
    }
  }

  Future<void> _convertNewWaypointMarkerToDestinationMarker(
      final int index) async {
    final String title = 'Waypoint $index';
    final ImageDescriptor waypointMarkerImage = ImageDescriptor.defaultImage;
    final List<Marker?> destinationMarkers =
        await _navigationViewController!.updateMarkers(<Marker>[
      _newWaypointMarker!.copyWith(
        options: _newWaypointMarker!.options.copyWith(
          infoWindow: InfoWindow(title: title),
          anchor: const MarkerAnchor(u: 0.5, v: 1.2),
          icon: waypointMarkerImage,
        ),
      )
    ]);
    _destinationWaypointMarkers.add(destinationMarkers.first!);
    _newWaypointMarker = null;
  }

  Future<bool> _updateNavigationDestinations() async {
    if (_navigationViewController == null || _waypoints.isEmpty) {
      return false;
    }

    if (!_navigatorInitialized) {
      await _initializeNavigator();
    }

    final Destinations? destinations = _buildDestinations();

    if (destinations == null) {
      setState(() {
        _errorOnSetDestinations = true;
      });
      return false;
    }

    try {
      final NavigationRouteStatus navRouteStatus =
          await GoogleMapsNavigator.setDestinations(destinations);

      switch (navRouteStatus) {
        case NavigationRouteStatus.statusOk:
          // Route is valid. Return true as success.
          setState(() {
            _errorOnSetDestinations = false;
          });
          return true;
        case NavigationRouteStatus.internalError:
          ScaffoldHelpers.showScaffold(context,
              'Unexpected internal error occured. Please restart the app.');
        case NavigationRouteStatus.routeNotFound:
          ScaffoldHelpers.showScaffold(
              context, 'The route could not be calculated.');
        case NavigationRouteStatus.networkError:
          ScaffoldHelpers.showScaffold(context,
              'Working network connection is required to calculate the route.');
        case NavigationRouteStatus.quotaExceeded:
          ScaffoldHelpers.showScaffold(
              context, 'Insufficient API quota to use the navigation.');
        case NavigationRouteStatus.quotaCheckFailed:
          ScaffoldHelpers.showScaffold(context,
              'API quota check failed, cannot authorize the navigation.');
        case NavigationRouteStatus.apiKeyNotAuthorized:
          ScaffoldHelpers.showScaffold(
              context, 'A valid API key is required to use the navigation.');
        case NavigationRouteStatus.statusCanceled:
          ScaffoldHelpers.showScaffold(context,
              'The route calculation was canceled in favor of a newer one.');
        case NavigationRouteStatus.duplicateWaypointsError:
          ScaffoldHelpers.showScaffold(context,
              'The route could not be calculated because of duplicate waypoints.');
        case NavigationRouteStatus.noWaypointsError:
          ScaffoldHelpers.showScaffold(context,
              'The route could not be calculated because no waypoints were provided.');
        case NavigationRouteStatus.locationUnavailable:
          ScaffoldHelpers.showScaffold(context,
              'No user location is available. Did you allow location permission?');
        case NavigationRouteStatus.waypointError:
          ScaffoldHelpers.showScaffold(context, 'Invalid waypoints provided.');
        case NavigationRouteStatus.travelModeUnsupported:
          ScaffoldHelpers.showScaffold(context,
              'The route could not calculated for the given travel mode.');
        case NavigationRouteStatus.unknown:
          ScaffoldHelpers.showScaffold(context,
              'The route could not be calculated due to an unknown error.');
        case NavigationRouteStatus.locationUnknown:
          ScaffoldHelpers.showScaffold(context,
              'The route could not be calculated, because the user location is unknown.');
      }
    } on RouteTokenMalformedException catch (_) {
      ScaffoldHelpers.showScaffold(context, 'Malformed route token');
    } on SessionNotInitializedException catch (_) {
      ScaffoldHelpers.showScaffold(
          context, 'Cannot set destinations, session not initialized');
    }
    setState(() {
      _errorOnSetDestinations = true;
    });
    return false;
  }

  Destinations? _buildDestinations() {
    // Show delayed calculating route message.
    unawaited(showCalculatingRouteMessage());

    return Destinations(
      waypoints: _waypoints,
      displayOptions: NavigationDisplayOptions(
        showDestinationMarkers: false,
        showStopSigns: true,
        showTrafficLights: true,
      ),
      routingOptions: RoutingOptions(travelMode: _travelMode),
    );
  }

  Future<void> _showNativeNavigatorState() async {
    if (await GoogleMapsNavigator.isInitialized()) {
      ScaffoldHelpers.showScaffold(context, 'Navigator initialized');
    } else {
      ScaffoldHelpers.showScaffold(context, 'Navigator not inititalized');
    }
  }

  Future<void> _resetTOS() async {
    await GoogleMapsNavigator.resetTermsAccepted();
    await _updateTermsAcceptedState();
  }

  Future<void> _setPadding(EdgeInsets padding) async {
    try {
      await _navigationViewController!.setPadding(padding);
      setState(() {
        _mapPadding = padding;
      });
    } catch (e) {
      ScaffoldHelpers.showScaffold(context, e.toString());
    }
  }

//starting route
  Future<void> _startGuidance() async {
    await GoogleMapsNavigator.startGuidance();
    setState(() {
      _guidanceRunning = true;
    });
  }

//stopping route
  Future<void> _stopGuidance() async {
    await GoogleMapsNavigator.stopGuidance();
    setState(() {
      _guidanceRunning = false;
    });
  }

  @override
  Widget build(BuildContext context) => buildPage(
      context,
      (BuildContext context) => Padding(
          padding: EdgeInsets.zero,
          child: Stack(
            children: <Widget>[
              Column(children: <Widget>[
                _createRemainingTimeAndDistanceLabels(),
                if (route == null) _createGoBackBtn(),
                if (route != null) _createFinishedRouteDetails(),
                Expanded(
                  child: _navigatorInitializedAtLeastOnce &&
                          _userLocation != null
                      ? GoogleMapsNavigationView(
                          onViewCreated: _onViewCreated,
                          onRecenterButtonClicked:
                              _onRecenterButtonClickedEvent,
                          onNavigationUIEnabledChanged:
                              _onNavigationUIEnabledChanged,
                          initialCameraPosition: CameraPosition(
                            // Initialize map to user location.
                            target: _userLocation!,
                            zoom: 15,
                          ),
                          initialNavigationUIEnabledPreference: _guidanceRunning
                              ? NavigationUIEnabledPreference.automatic
                              : NavigationUIEnabledPreference.disabled,
                          initialPadding: const EdgeInsets.all(0))
                      : const Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text('Waiting navigator and user location'),
                              SizedBox(height: 10),
                              SizedBox(
                                  width: 30,
                                  height: 30,
                                  child: CircularProgressIndicator())
                            ],
                          ),
                        ),
                ),
                if (_navigationViewController != null) bottomControls
              ]),
            ],
          )));

  Widget get bottomControls {
    if (!_termsAndConditionsAccepted || !_locationPermissionsAccepted) {
      return Padding(
          padding: const EdgeInsets.all(15),
          child: Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              children: <Widget>[
                const Text(
                    'Terms and conditions and location permissions must be accepted'
                    ' before navigation can be started.'),
                getOptionsButton(context, onPressed: () => toggleOverlay())
              ]));
    }
    if (!_navigatorInitializedAtLeastOnce) {
      return const Text('Waiting for navigator to initialize...');
    }
    return Padding(
      padding: const EdgeInsets.all(15),
      child: Column(
        children: <Widget>[
          if (_errorOnSetDestinations && _waypoints.isNotEmpty) ...<Widget>[
            const Text('Error while setting destinations'),
            ElevatedButton(
              onPressed: _retryToUpdateNavigationDestinations,
              child: const Text('Retry'),
            ),
          ],
          if (_waypoints.isNotEmpty)
            Wrap(
              alignment: WrapAlignment.center,
              spacing: 10,
              children: <Widget>[
                if (!_guidanceRunning)
                  ElevatedButton.icon(
                    onPressed: _validRoute ? _startGuidedNavigation : null,
                    icon: Icon(Icons.play_arrow),
                    label: const Text('Start Guidance'),
                  ),
                if (_guidanceRunning)
                  ElevatedButton.icon(
                    onPressed: _validRoute ? _stopGuidedNavigation : null,
                    icon: Icon(Icons.stop),
                    label: const Text('Stop Guidance'),
                  ),
              ],
            ),
          if (_waypoints.isEmpty)
            const Padding(
              padding: EdgeInsets.all(15),
              child: Text(
                'Click on buttons to add source and destination points or you can go back to the previous screen',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
            ),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            children: <Widget>[
              ElevatedButton.icon(
                onPressed: _sourcePointEnabled ? _addSourcePoint : null,
                icon: Icon(Icons.add),
                label: const Text('Add source point'),
              ),
              ElevatedButton.icon(
                onPressed:
                    _destinationPointEnabled ? _addDestinationPoint : null,
                icon: Icon(Icons.add),
                label: const Text('Add destination point'),
              ),
              ElevatedButton.icon(
                onPressed: _waypoints.isNotEmpty && !_guidanceRunning
                    ? () => _clearNavigationWaypoints()
                    : null,
                icon: Icon(Icons.clear),
                label: const Text('Clear waypoints'),
              ),
              getOptionsButton(context, onPressed: () => toggleOverlay())
            ],
          ),
        ],
      ),
    );
  }

  Widget _createGoBackBtn() {
    return SafeArea(
        minimum: const EdgeInsets.all(8.0),
        child: Align(
            alignment: Alignment.bottomRight,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                ElevatedButton.icon(
            onPressed: () async {
              Navigator.of(context).pushReplacement(
                MaterialPageRoute(
                  builder: (context) => DrivesScreen(),
                ),
              );
            },
            icon: Icon(Icons.arrow_back),
            label: Text(
              "Go back",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.yellowAccent,
              foregroundColor: Colors.black,
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
              ],
            )));
  }

  Widget _createRemainingTimeAndDistanceLabels() {
    return SafeArea(
        minimum: const EdgeInsets.all(8.0),
        child: Align(
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Card(
                  color: const Color.fromARGB(255, 252, 236, 204),
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Remaining time: ${formatRemainingDuration(Duration(seconds: _remainingTime))}',
                        style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'Remaining distance: ${formatRemainingDistance(_remainingDistance)}',
                        style: const TextStyle(fontSize: 15,fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                )),
              ],
            )));
  }

  Widget _createFinishedRouteDetails() {
    return SafeArea(
        minimum: const EdgeInsets.all(8.0),
        child: Align(
            alignment: Alignment.topLeft,
            child: Row(
              children: [
                Card(
                  color: const Color.fromARGB(255, 181, 208, 255),
                    child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Full price: ${route?.fullPrice?.toString() ?? ""} KM',
                        style: const TextStyle(
                            fontSize: 15, fontWeight: FontWeight.bold),
                      ),
                      route?.paid != null
                          ? Text(
                              'Paid: ${route?.paid!}',
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            )
                          : Text(
                              'Customer did not pay the drive',
                              style: const TextStyle(
                                  fontSize: 15, fontWeight: FontWeight.bold),
                            ),
                    ],
                  ),
                )),
                SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => DrivesScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      minimumSize: Size(100, 50),
                    ),
                    child: Text("Finish")),
              ],
            )));
  }

  void _showNavigationEventListenerCallCounts(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
            padding: const EdgeInsets.all(16.0),
            child: ListView(
              children: <Widget>[
                Card(
                    child: ListTile(
                  title: const Text('On route changed event call count'),
                  trailing: Text(_onRouteChangedEventCallCount.toString()),
                )),
                Card(
                    child: ListTile(
                  title: const Text(
                      'On road snapped location updated event call count'),
                  trailing: Text(
                      _onRoadSnappedLocationUpdatedEventCallCount.toString()),
                )),
                if (Platform.isAndroid)
                  Card(
                      child: ListTile(
                    title: const Text(
                        'On road snapped raw location updated event call count'),
                    trailing: Text(
                        _onRoadSnappedRawLocationUpdatedEventCallCount
                            .toString()),
                  )),
                Card(
                    child: ListTile(
                  title: const Text('On traffic updated event call count'),
                  trailing: Text(_onTrafficUpdatedEventCallCount.toString()),
                )),
                Card(
                    child: ListTile(
                  title: const Text('On rerouting event call count'),
                  trailing: Text(_onReroutingEventCallCount.toString()),
                )),
                if (Platform.isAndroid)
                  Card(
                      child: ListTile(
                    title: const Text('On GPS availability event call count'),
                    trailing: Text(_onGpsAvailabilityEventCallCount.toString()),
                  )),
                Card(
                    child: ListTile(
                  title: const Text('On arrival event call count'),
                  trailing: Text(_onArrivalEventCallCount.toString()),
                )),
                Card(
                    child: ListTile(
                  title: const Text('On speeding updated event call count'),
                  trailing: Text(_onSpeedingUpdatedEventCallCount.toString()),
                )),
                Card(
                    child: ListTile(
                  title:
                      const Text('On recenter button clicked event call count'),
                  trailing:
                      Text(_onRecenterButtonClickedEventCallCount.toString()),
                )),
                Card(
                    child: ListTile(
                  title: const Text(
                      'On remaining time or distance changed event call count'),
                  trailing: Text(_onRemainingTimeOrDistanceChangedEventCallCount
                      .toString()),
                )),
                Card(
                    child: ListTile(
                  title: const Text(
                      'On navigation UI enabled changed event call count'),
                  trailing: Text(
                      _onNavigationUIEnabledChangedEventCallCount.toString()),
                )),
              ],
            ));
      },
    );
  }

  @override
  Widget buildOverlayContent(BuildContext context) {
    Color? getExpansionTileTextColor(bool disabled) {
      return disabled ? Theme.of(context).disabledColor : null;
    }

    return Column(children: <Widget>[
      Card(
        child: ExpansionTile(
          title: const Text('Terms and conditions'),
          children: <Widget>[
            Wrap(
                alignment: WrapAlignment.center,
                spacing: 10,
                children: <Widget>[
                  ElevatedButton(
                    onPressed: !_termsAndConditionsAccepted
                        ? () => _showTermsAndConditionsDialogIfNeeded()
                        : null,
                    child: const Text('Show TOS'),
                  ),
                  ElevatedButton(
                    onPressed:
                        _termsAndConditionsAccepted ? () => _resetTOS() : null,
                    child: const Text('Reset TOS'),
                  ),
                ]),
            const SizedBox(height: 10)
          ],
        ),
      ),
      Card(
        child:
            ExpansionTile(title: const Text('Navigation'), children: <Widget>[
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 10,
            children: <Widget>[
              ElevatedButton(
                onPressed: !_navigatorInitialized
                    ? () => _initializeNavigator()
                    : null,
                child: const Text('Start navigation'),
              ),
              ElevatedButton(
                onPressed: _navigatorInitialized
                    ? () => _stopGuidedNavigation()
                    : null,
                child: const Text('Stop navigation'),
              ),
              ElevatedButton(
                onPressed: _navigatorInitialized
                    ? (_guidanceRunning ? _stopGuidance : _startGuidance)
                    : null,
                child:
                    Text(_guidanceRunning ? 'Stop guidance' : 'Start guidance'),
              ),
              ElevatedButton(
                onPressed: () =>
                    _showNavigationEventListenerCallCounts(context),
                child: const Text('Show listeners'),
              ),
              ElevatedButton(
                onPressed: () => _showNativeNavigatorState(),
                child: const Text('Show native navigator state'),
              ),
            ],
          ),
          const SizedBox(height: 10)
        ]),
      ),
      IgnorePointer(
          ignoring: !_navigatorInitialized || _navigationViewController == null,
          child: Card(
            child: ExpansionTile(
                title: const Text('Navigation view'),
                collapsedTextColor: getExpansionTileTextColor(
                    !_navigatorInitialized ||
                        _navigationViewController == null),
                collapsedIconColor: getExpansionTileTextColor(
                    !_navigatorInitialized ||
                        _navigationViewController == null),
                children: <Widget>[
                  ExampleSwitch(
                      title: 'Enable guidance header',
                      initialValue: _navigationHeaderEnabled,
                      onChanged: (bool newValue) async {
                        await _navigationViewController!
                            .setNavigationHeaderEnabled(newValue);
                        setState(() {
                          _navigationHeaderEnabled = newValue;
                        });
                      }),
                  ExampleSwitch(
                      title: 'Enable footer',
                      initialValue: _navigationFooterEnabled,
                      onChanged: (bool newValue) async {
                        await _navigationViewController!
                            .setNavigationFooterEnabled(newValue);
                        setState(() {
                          _navigationFooterEnabled = newValue;
                        });
                      }),
                  ExampleSwitch(
                      title: 'Enable Navigation UI',
                      initialValue: _navigationUIEnabled,
                      onChanged: (bool newValue) async {
                        await _navigationViewController!
                            .setNavigationUIEnabled(newValue);
                        setState(() {
                          _navigationUIEnabled = newValue;
                        });
                      }),
                  ExampleSwitch(
                      title: 'Enable recenter button',
                      initialValue: _recenterButtonEnabled,
                      onChanged: (bool newValue) async {
                        await _navigationViewController!
                            .setRecenterButtonEnabled(newValue);
                        setState(() {
                          _recenterButtonEnabled = newValue;
                        });
                      }),
                ]),
          )),
      IgnorePointer(
          ignoring: !_navigatorInitialized || _navigationViewController == null,
          child: Card(
            child: ExpansionTile(
                title: const Text('Camera'),
                collapsedTextColor: getExpansionTileTextColor(
                    !_navigatorInitialized ||
                        _navigationViewController == null),
                collapsedIconColor: getExpansionTileTextColor(
                    !_navigatorInitialized ||
                        _navigationViewController == null),
                children: <Widget>[
                  Wrap(
                      alignment: WrapAlignment.center,
                      spacing: 10,
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () =>
                              _navigationViewController!.showRouteOverview(),
                          child: const Text('Route overview'),
                        ),
                        ElevatedButton(
                          onPressed: () => _navigationViewController!
                              .followMyLocation(CameraPerspective.tilted),
                          child: const Text('Follow my location'),
                        )
                      ]),
                  const SizedBox(height: 10)
                ]),
          )),
    ]);
  }

  Future<void> _onViewCreated(GoogleNavigationViewController controller) async {
    setState(() {
      _navigationViewController = controller;
    });
    await controller.setMyLocationEnabled(true);

    if (_guidanceRunning) {
      // guidance is running, enable navigation UI.
      await _startGuidedNavigation();
    }

    await _getInitialViewStates();
  }

  Future<void> _retryToUpdateNavigationDestinations() async {
    setState(() {
      _errorOnSetDestinations = false;
    });
    await _updateNavigationDestinationsAndNavigationViewState();
  }

  /*@override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Navigation"),
        actions: [
          ElevatedButton(
            onPressed: () {
              AlertHelpers.showAlert(context, "Info", "Still not implemented");
            },
            child: Text("Finish Drive"),
          ),
        ],
      ),
      body: _buildNavigation(),
    );
  }

  Widget _buildNavigation() {
    return _navigationSessionInitialized
        ? GoogleMapsNavigationView(
            onViewCreated: _onViewCreated,
            initialNavigationUIEnabledPreference:
                NavigationUIEnabledPreference.disabled,
            initialCameraPosition:
                CameraPosition(target: _userLocation!, zoom: 15),
          )
        : const Center(child: CircularProgressIndicator());
  }

  void _onViewCreated(GoogleNavigationViewController controller) {
    _navigationViewController = controller;
    controller.setMyLocationEnabled(true);
  }*/
}
