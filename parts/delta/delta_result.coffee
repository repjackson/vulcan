if Meteor.isClient
    Template.delta_list_result.onRendered ->
        # Meteor.setTimeout ->
        #     $('.progress').popup()
        # , 2000
    Template.delta_list_result.onCreated ->
        @autorun => Meteor.subscribe 'doc', @data._id
        @autorun => Meteor.subscribe 'user_from_id', @data._id

    Template.delta_list_result.helpers
        template_exists: ->
            current_model = Router.current().params.model_slug
            if current_model
                if Template["#{current_model}_item"]
                    # console.log 'true'
                    return true
                else
                    # console.log 'false'
                    return false

        model_template: ->
            current_model = Router.current().params.model_slug
            "#{current_model}_item"

        toggle_value_class: ->
            facet = Template.parentData()
            delta = Docs.findOne model:'delta'
            if Session.equals 'loading', true
                 'disabled'
            else if facet.filters.length > 0 and @name in facet.filters
                'active'
            else ''

        result: ->
            if Docs.findOne @_id
                # console.log 'doc'
                result = Docs.findOne @_id
                if result.private is true
                    if result._author_id is Meteor.userId()
                        result
                else
                    result
            else if Meteor.users.findOne @_id
                # console.log 'user'
                Meteor.users.findOne @_id

    Template.delta_list_result.events
        'click .result': (e,t)->
            # console.log @
            model_slug =  Router.current().params.model_slug
            $(e.currentTarget).closest('.result').transition('fade')
            if Meteor.user()
                Docs.update @_id,
                    $inc: views: 1
                    $addToSet:viewer_usernames:Meteor.user().username
            # else
            #     Docs.update @_id,
            #         $inc: views: 1
            delta = Docs.findOne model:'delta'
            Docs.update delta._id,
                $set:search_query:null

            if model_slug is 'model'
                Session.set 'loading', true
                Meteor.call 'set_facets', @slug, ->
                    Session.set 'loading', false

            if @model is 'model'
                Router.go "/m/#{@slug}"
            else
                Router.go "/m/#{model_slug}/#{@_id}/view"

        'click .set_model': ->
            Meteor.call 'set_delta_facets', @slug, Meteor.userId()

        'click .route_model': ->
            Session.set 'loading', true
            Meteor.call 'set_facets', @slug, ->
                Session.set 'loading', false
            # delta = Docs.findOne model:'delta'
            # Docs.update delta._id,
            #     $set:model_filter:@slug
            #
            # Meteor.call 'fum', delta._id, (err,res)->
