class RdioDisplay

  DEBUG = false

  constructor: ->
    @initiated = false
    @showingTrack = false
    @firstTrackAdded = false

    @$main = $('[role="main"]')
    @$background = $('.fixed-background')

    R.ready(this.init)

  init: =>
    return this.showAuthentication() unless R.authenticated()
    this.showCurrentSong()

  # Display
  showCurrentSong: ->
    this.initEvents() unless @initiated
    track = R.player.playingTrack()
    this.showTrack(track)

  showTrack: (track) ->
    this.log('showTrack', track)
    return this.showEmptyTrack() unless track

    newTrackAlbum = track.get('album') != @trackAlbum

    @trackImage = track.get('icon').replace('200.jpg', '600.jpg')
    @trackName = track.get('name')
    @trackArtist = track.get('artist')
    @trackAlbum = track.get('album')

    $previousTrackInfo = $('.track-info')

    if newTrackAlbum || !$previousTrackInfo.length
      @$trackInfo = $("<div class='track-info #{if !@firstTrackAdded then 'track-info-in' else ''}'></div>")
      @$trackName = $("<div class='track-name'>#{@trackName}</div>")
      @$trackArtist = $("<div class='track-artist'>#{@trackArtist}</div>")
      @$trackAlbum = $("<div class='track-album'>#{@trackAlbum}</div>")

      @$trackInfo.append(@$trackName)
      @$trackInfo.append(@$trackArtist)
      @$trackInfo.append(@$trackAlbum)
      @$track.append(@$trackInfo)

      img = new Image
      img.onload = (e) =>
        this.setShowingTrack() unless @showingTrack
        this.updateImage()
        setTimeout =>
          @$trackInfo.addClass('track-info-in')
          $previousTrackInfo.addClass('track-info-out')
        , 0
        setTimeout this.removeOldTrackInfo, 500
        @$background.css('background-image', "url(#{@trackImage})")

        return if @firstTrackAdded
        @firstTrackAdded = true
      img.src = @trackImage
    else
      @$trackName.html(@trackName)
      @$trackArtist.html(@trackArtist)

  removeOldTrackInfo: ->
    $('.track-info-out').remove()

  updateImage: ->
    if @firstTrackAdded
      $trackImage = if this.imageTrackIsFlipped() then @$trackImageFront else @$trackImageBack
      @$trackImage.toggleClass('track-image-flipped')
    else
      $trackImage = @$trackImage.children('img')

    $trackImage.attr('src', @trackImage)

  imageTrackIsFlipped: ->
    @$trackImage.hasClass('track-image-flipped')

  showEmptyTrack: ->
    this.log('showEmptyTrack')

  setShowingTrack: ->
    @showingTrack = true
    @$main.addClass('showing-track')

  # Events
  initEvents: ->
    @initiated = true

    @$track = $('.track')
    @$trackImage = @$track.children('.track-image')
    @$trackImageFront = @$trackImage.children('.front')
    @$trackImageBack = @$trackImage.children('.back')
    # @$trackInfo = @$track.children('.track-info')
    # @$trackName = @$trackInfo.children('.track-name')
    # @$trackArtist = @$trackInfo.children('.track-artist')
    # @$trackAlbum = @$trackInfo.children('.track-album')

    R.player.on 'change:playState', this.onPlayStateChange
    R.player.on 'change:playingTrack', this.onPlayingTrackChange

  onPlayStateChange: (isPlaying) =>
    this.log('onPlayStateChange', isPlaying)

  onPlayingTrackChange: (track) =>
    this.log('onPlayingTrackChange')
    this.showTrack(track)

  # Authentication
  authenticate: ->
    R.authenticate (authenticated) =>
      this.showCurrentSong() if authenticated

  showAuthentication: ->
    @$main.addClass('authentication')

  # Debug
  log: ->
    return unless DEBUG
    console.log(argument) for argument in arguments

# Global Scope
window.RdioDisplay = new RdioDisplay
