Template.single_doc_view.onCreated ->
    @autorun => Meteor.subscribe 'doc', Template.parentData(5)["#{@data.key}"]

Template.single_doc_view.helpers
    related_doc: ->
        field_value =  Template.parentData(5)["#{@key}"]
        Docs.findOne field_value
        # console.log Template.currentData()

    choices: ->
        console.log @
        model = Docs.findOne @ref_model
        Docs.find
            model:model.slug





Template.single_doc_edit.onCreated ->
    if @data.ref_model_slug
        @autorun => Meteor.subscribe 'model_docs_from_model_id', @data.ref_model_slug
    else if @data.ref_model
        @autorun => Meteor.subscribe 'model_docs_from_model_id', @data.ref_model_slug
    @autorun => Meteor.subscribe 'doc', @data.ref_model

Template.single_doc_edit.helpers
    choices: ->
        console.log @
        if @direct
            console.log @ref_model_slug
            Docs.find {
                model:@ref_model_slug
            }, sort:title:1
        else
            console.log @ref_model
            model = Docs.findOne @ref_model
            Docs.find {
                model:model.slug
            }, sort: title:1

    calculated_label: ->
        ref_doc = Template.currentData()
        key = Template.parentData().button_label
        ref_doc["#{key}"]

    choice_class: ->
        selection = @
        current = Template.currentData()
        ref_field = Template.parentData(1)
        if ref_field.direct
            parent = Template.parentData(2)
            # target = Docs.findOne Router.current().params.doc_id
            target = Template.parentData(2)
        else
            parent = Template.parentData(6)
            target = Template.parentData(2)

        # console.log 'target', target
        # console.log 'parent', parent
        # console.log 'ref field', ref_field
        # console.log  Template.parentData(1)
        # console.log Template.parentData(2)
        # console.log Template.parentData(3)
        # console.log   Template.parentData(4)
        # console.log   Template.parentData(5)
        # console.log   Template.parentData(6)
        # console.log   Template.parentData(7)

        if @direct
            if parent["#{ref_field.key}"]
                if @_id is parent["#{ref_field.key}"] then 'active' else 'basic'
            else ''
        else
            if parent["#{ref_field.key}"]
                if @_id is parent["#{ref_field.key}"] then 'active' else 'basic'
            else 'basic'


Template.single_doc_edit.events
    'click .select_choice': ->
        selection = @
        ref_field = Template.currentData()
        if ref_field.direct
            parent = Template.parentData()
        else
            parent = Template.parentData(5)
        # parent = Template.parentData(1)

        # key = ref_field.button_key
        key = ref_field.key
        # if parent["#{key}"] and @["#{ref_field.button_key}"] in parent["#{key}"]
        if parent["#{key}"] and @slug in parent["#{key}"]
            doc = Docs.findOne parent._id
            user = Meteor.users.findOne parent._id
            if doc
                Docs.update parent._id,
                    $unset:"#{ref_field.key}":1
            else if user
                Meteor.users.update parent._id,
                    $unset: "#{ref_field.key}":1
        else
            doc = Docs.findOne parent._id
            user = Meteor.users.findOne parent._id
            if doc
                Docs.update parent._id,
                    $set: "#{ref_field.key}": @_id
            else if user
                Meteor.users.update parent._id,
                    $set: "#{ref_field.key}": @_id



Template.multi_doc_view.onCreated ->
    @autorun => Meteor.subscribe 'model_docs_from_model_id', @data.ref_model
    @autorun => Meteor.subscribe 'doc', @data.ref_model

Template.referenced_doc.helpers
    context_doc: ->
        # console.log @
        Docs.findOne {
            _id: @valueOf()
        }



# Template.multi_doc.onRendered ->
#     $('.ui.dropdown').dropdown(
#         clearable:true
#         action: 'activate'
#         onChange: (text,value,$selectedItem)->
#         )



Template.multi_doc_edit.onCreated ->
    if @data.direct
        @autorun => Meteor.subscribe 'model_docs_from_model_slug', @data.ref_model_slug
    else
        @autorun => Meteor.subscribe 'model_docs_from_model_id', @data.ref_model_id
    @autorun => Meteor.subscribe 'doc', @data.ref_model_id
Template.multi_doc_edit.helpers
    multi_choices: ->
        if @direct
            Docs.find {
                model:@ref_model_slug
            }, sort: title:1
        else if @ref_model_id
            model = Docs.findOne @ref_model
            Docs.find {
                model:model.slug
            }, sort: title:1

    choice_class: ->
        selection = @
        current = Template.currentData()
        if @direct
            parent = Template.parentData()
        else
            parent = Template.parentData(6)
        ref_field = Template.parentData(1)
        target = Template.parentData(2)

        # console.log @
        # console.log 'ref_field', ref_field
        # console.log 'target', target
        # console.log 'parent', parent


        if parent["#{ref_field.key}"]
            if @_id in parent["#{ref_field.key}"] then 'active' else 'basic'
        else
            'basic'

Template.multi_doc_edit.events
    'click .select_choice': ->
        selection = @
        ref_field = Template.currentData()
        if ref_field.direct
            parent = Template.parentData(2)
        else
            parent = Template.parentData(5)
        # console.log  Template.parentData(1)
        # console.log Template.parentData(2)
        # console.log Template.parentData(3)
        # console.log   Template.parentData(4)
        # console.log   Template.parentData(5)
        # console.log   Template.parentData(6)
        # console.log   Template.parentData(7)

        if parent["#{ref_field.key}"] and @_id in parent["#{ref_field.key}"]
            doc = Docs.findOne parent._id
            user = Meteor.users.findOne parent._id
            if doc
                Docs.update parent._id,
                    $pull:"#{ref_field.key}":@_id
            else if user
                Meteor.users.update parent._id,
                    $pull: "#{ref_field.key}": @_id
        else
            doc = Docs.findOne parent._id
            user = Meteor.users.findOne parent._id
            if doc
                Docs.update parent._id,
                    $addToSet: "#{ref_field.key}": @_id
            else if user
                Meteor.users.update parent._id,
                    $addToSet: "#{ref_field.key}": @_id




Template.single_user_edit.onCreated ->
    @user_results = new ReactiveVar
Template.single_user_edit.helpers
    user_results: ->Template.instance().user_results.get()
Template.single_user_edit.events
    'click .clear_results': (e,t)->
        t.user_results.set null

    'keyup #single_user_select_input': (e,t)->
        search_value = $(e.currentTarget).closest('#single_user_select_input').val().trim()
        if search_value.length > 1
            Meteor.call 'lookup_user', search_value, @role_filter, (err,res)=>
                if err then console.error err
                else
                    t.user_results.set res

    'click .select_user': (e,t) ->
        # page_doc = Docs.findOne Router.current().params.id
        field = Template.currentData()

        val = t.$('.edit_text').val()
        if field.direct
            parent = Template.parentData()
        else
            parent = Template.parentData(5)


        doc = Docs.findOne parent._id
        user = Meteor.users.findOne parent._id
        if doc
            Docs.update parent._id,
                $set:"#{field.key}":@username
        else if user
            Meteor.users.update parent._id,
                $set:"#{field.key}":@username

        t.user_results.set null
        $('#single_user_select_input').val ''
        # Docs.update page_doc._id,
        #     $set: assignment_timestamp:Date.now()

    'click .pull_user': ->
        parent = Template.parentData()
        console.log Template.parentData(5)
        # parent = Template.parentData(5)
        field = Template.currentData()
        Docs.update parent._id,
            $unset:"#{field.key}":1

        # if confirm "Remove #{@username}?"
        #     page_doc = Docs.findOne Router.current().params.id
            # Meteor.call 'unassign_user', page_doc._id, @
