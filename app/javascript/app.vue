<template>
<div id="app">
  <div id="map">
  </div>
  <b-modal id="modal1" ref="modal1" :title="title" size="lg">
    <table class="table table-bordered">
      <thead clas="thead-dark">
        <tr>
          <th class="nowrap">機関</th>
          <th>課題名</th>
          <th>メンバー</th>
          <th>リンク</th>
        </tr>
      </thead>
      <tbody>
        <tr v-for="research in researches">
          <td>{{research.institution}}</td>
          <td>{{research.title}}</td>
          <td>
            <p v-for="member in research.members">
              {{member.name}} ({{member.institution}}, {{member.department}}, {{member.jobTitle}})
            </p>
          </td>
          <td><a :href="`https://kaken.nii.ac.jp/ja/grant/${research.id}/`" target="_blank">{{research.id}}</a></td>
        </tr>
      </tbody>
    </table>
  </b-modal>
</div>
</template>

<script>
import L from 'leaflet'
// https://github.com/PaulLeCam/react-leaflet/issues/255#issuecomment-269750542
delete L.Icon.Default.prototype._getIconUrl;
L.Icon.Default.mergeOptions({
  iconRetinaUrl: require('leaflet/dist/images/marker-icon-2x.png'),
  iconUrl: require('leaflet/dist/images/marker-icon.png'),
  shadowUrl: require('leaflet/dist/images/marker-shadow.png'),
});
import 'leaflet.markercluster'
import axios from 'axios'
export default {
  methods: {
    showDialog(e) {
      var vm = this;

      var title = e.target.options.title;
      vm.title = title;
      vm.researches = []
      vm.$refs.modal1.show();
      axios
        .get('/researches.json', {
          params: {
            keywords: vm.title
          }
        })
        .then(function(response) {
          vm.researches = []
            response.data.forEach((research) => {
              vm.researches.push(research)
            })
        })
        .catch(function(error) {
          // TODO
          vm.researches.push({
            institution: '',
            name: '',
            member: []
          })
          console.log(error);
        })


    }
  },
  mounted() {
    this.$nextTick(function() {


      var map = L.map('map').fitWorld();
      L.tileLayer('https://cyberjapandata.gsi.go.jp/xyz/std/{z}/{x}/{y}.png', {
        attribution: '&copy; <a href="http://osm.org/copyright">OpenStreetMap</a> contributors'
      }).addTo(map);
      var vm = this;
      axios
        .get('/attractions')
        .then(function(response) {
          var markers = L.markerClusterGroup();
          var attrs = response.data;
          attrs.forEach((attr) => {
            var title = attr.resourceName;
            var marker = L.marker(new L.LatLng(attr.lat, attr.lng), {
              title: title
            });
            marker.on('click', vm.showDialog);
            // marker.bindPopup(title);
            markers.addLayer(marker);
          })
          map.addLayer(markers);
        })
        .catch(function(error) {
          // TODO
          console.log(error);
        })

      // L.marker([51.5, -0.09]).addTo(map)
      //   .bindPopup('A pretty CSS3 popup.<br> Easily customizable.')
      //   .openPopup();


      function onLocationFound(e) {
        var radius = e.accuracy / 2;
        // L.marker(e.latlng).addTo(map)
        // .bindPopup("You are within " + radius + " meters from this point").openPopup();
        L.circle(e.latlng, radius).addTo(map);
      }

      function onLocationError(e) {
        alert(e.message);
      }
      map.on('locationfound', onLocationFound);
      map.on('locationerror', onLocationError);
      map.locate({
        setView: true,
        maxZoom: 14
      });
    })

  },
  data: function() {
    return {
      title: '',
      researches: [],
      message: "Hello Vue!"
    }
  }
}
</script>

<style lang="scss">
@import 'bootstrap-vue/dist/bootstrap-vue.css';
@import 'bootstrap/dist/css/bootstrap.css';
@import "~leaflet/dist/leaflet.css";
@import '~leaflet.markercluster/dist/MarkerCluster.css';
@import '~leaflet.markercluster/dist/MarkerCluster.Default.css';
body,
html {
    width: 100%;
    height: 100%;
    margin: 0;
    padding: 0;
}
div.modal-body {
    padding: 0;
}
#app,
#map {
    width: 100%;
    height: 100%;
}
</style>
