#!/bin/bash
echo "Setting Google Maps API Key..."
echo "googleMapsAPIKey=$(grep googleMapsAPIKey ios/Flutter/.env | cut -d '=' -f2)" > ios/Flutter/.env
