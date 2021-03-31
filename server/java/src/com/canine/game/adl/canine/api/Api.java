/* @generated from adl module canine.api */

package com.canine.game.adl.canine.api;

import com.canine.game.adl.common.http.HttpPost;
import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import org.adl.runtime.Builders;
import org.adl.runtime.Factories;
import org.adl.runtime.Factory;
import org.adl.runtime.HashSetHelpers;
import org.adl.runtime.JsonBinding;
import org.adl.runtime.JsonBindings;
import org.adl.runtime.Lazy;
import org.adl.runtime.TypeToken;
import org.adl.runtime.sys.adlast.ScopedName;
import org.adl.runtime.sys.adlast.TypeExpr;
import org.adl.runtime.sys.adlast.TypeRef;
import java.util.ArrayList;
import java.util.Objects;

public class Api {

  /* Members */

  private HttpPost<WithTimeStamp<PlayerActions>, EmptyObject> actions;
  private HttpPost<TimeStamp, WithTimeStamp<Model>> state;

  /* Constructors */

  public Api(HttpPost<WithTimeStamp<PlayerActions>, EmptyObject> actions, HttpPost<TimeStamp, WithTimeStamp<Model>> state) {
    this.actions = Objects.requireNonNull(actions);
    this.state = Objects.requireNonNull(state);
  }

  public Api() {
    this.actions = new HttpPost<WithTimeStamp<PlayerActions>, EmptyObject>("/player-actions", HashSetHelpers.create(Factories.arrayList("player")), new TypeToken<WithTimeStamp<PlayerActions>>(WithTimeStamp.jsonBinding(PlayerActions.jsonBinding())), new TypeToken<EmptyObject>(EmptyObject.jsonBinding()));
    this.state = new HttpPost<TimeStamp, WithTimeStamp<Model>>("/state", HashSetHelpers.create(Factories.arrayList("player")), new TypeToken<TimeStamp>(TimeStamp.jsonBinding()), new TypeToken<WithTimeStamp<Model>>(WithTimeStamp.jsonBinding(Model.jsonBinding())));
  }

  public Api(Api other) {
    this.actions = HttpPost.factory(WithTimeStamp.factory(PlayerActions.FACTORY), EmptyObject.FACTORY).create(other.actions);
    this.state = HttpPost.factory(TimeStamp.FACTORY, WithTimeStamp.factory(Model.FACTORY)).create(other.state);
  }

  /* Accessors and mutators */

  public HttpPost<WithTimeStamp<PlayerActions>, EmptyObject> getActions() {
    return actions;
  }

  public void setActions(HttpPost<WithTimeStamp<PlayerActions>, EmptyObject> actions) {
    this.actions = Objects.requireNonNull(actions);
  }

  public HttpPost<TimeStamp, WithTimeStamp<Model>> getState() {
    return state;
  }

  public void setState(HttpPost<TimeStamp, WithTimeStamp<Model>> state) {
    this.state = Objects.requireNonNull(state);
  }

  /* Object level helpers */

  @Override
  public boolean equals(Object other0) {
    if (!(other0 instanceof Api)) {
      return false;
    }
    Api other = (Api) other0;
    return
      actions.equals(other.actions) &&
      state.equals(other.state);
  }

  @Override
  public int hashCode() {
    int _result = 1;
    _result = _result * 37 + actions.hashCode();
    _result = _result * 37 + state.hashCode();
    return _result;
  }

  /* Builder */

  public static class Builder {
    private HttpPost<WithTimeStamp<PlayerActions>, EmptyObject> actions;
    private HttpPost<TimeStamp, WithTimeStamp<Model>> state;

    public Builder() {
      this.actions = new HttpPost<WithTimeStamp<PlayerActions>, EmptyObject>("/player-actions", HashSetHelpers.create(Factories.arrayList("player")), new TypeToken<WithTimeStamp<PlayerActions>>(WithTimeStamp.jsonBinding(PlayerActions.jsonBinding())), new TypeToken<EmptyObject>(EmptyObject.jsonBinding()));
      this.state = new HttpPost<TimeStamp, WithTimeStamp<Model>>("/state", HashSetHelpers.create(Factories.arrayList("player")), new TypeToken<TimeStamp>(TimeStamp.jsonBinding()), new TypeToken<WithTimeStamp<Model>>(WithTimeStamp.jsonBinding(Model.jsonBinding())));
    }

    public Builder setActions(HttpPost<WithTimeStamp<PlayerActions>, EmptyObject> actions) {
      this.actions = Objects.requireNonNull(actions);
      return this;
    }

    public Builder setState(HttpPost<TimeStamp, WithTimeStamp<Model>> state) {
      this.state = Objects.requireNonNull(state);
      return this;
    }

    public Api create() {
      return new Api(actions, state);
    }
  }

  /* Factory for construction of generic values */

  public static final Factory<Api> FACTORY = new Factory<Api>() {
    @Override
    public Api create() {
      return new Api();
    }

    @Override
    public Api create(Api other) {
      return new Api(other);
    }

    @Override
    public TypeExpr typeExpr() {
      ScopedName scopedName = new ScopedName("canine.api", "Api");
      ArrayList<TypeExpr> params = new ArrayList<>();
      return new TypeExpr(TypeRef.reference(scopedName), params);
    }
    @Override
    public JsonBinding<Api> jsonBinding() {
      return Api.jsonBinding();
    }
  };

  /* Json serialization */

  public static JsonBinding<Api> jsonBinding() {
    final Lazy<JsonBinding<HttpPost<WithTimeStamp<PlayerActions>, EmptyObject>>> actions = new Lazy<>(() -> HttpPost.jsonBinding(WithTimeStamp.jsonBinding(PlayerActions.jsonBinding()), EmptyObject.jsonBinding()));
    final Lazy<JsonBinding<HttpPost<TimeStamp, WithTimeStamp<Model>>>> state = new Lazy<>(() -> HttpPost.jsonBinding(TimeStamp.jsonBinding(), WithTimeStamp.jsonBinding(Model.jsonBinding())));
    final Factory<Api> _factory = FACTORY;

    return new JsonBinding<Api>() {
      @Override
      public Factory<Api> factory() {
        return _factory;
      }

      @Override
      public JsonElement toJson(Api _value) {
        JsonObject _result = new JsonObject();
        _result.add("actions", actions.get().toJson(_value.actions));
        _result.add("state", state.get().toJson(_value.state));
        return _result;
      }

      @Override
      public Api fromJson(JsonElement _json) {
        JsonObject _obj = JsonBindings.objectFromJson(_json);
        return new Api(
          _obj.has("actions") ? JsonBindings.fieldFromJson(_obj, "actions", actions.get()) : new HttpPost<WithTimeStamp<PlayerActions>, EmptyObject>("/player-actions", HashSetHelpers.create(Factories.arrayList("player")), new TypeToken<WithTimeStamp<PlayerActions>>(WithTimeStamp.jsonBinding(PlayerActions.jsonBinding())), new TypeToken<EmptyObject>(EmptyObject.jsonBinding())),
          _obj.has("state") ? JsonBindings.fieldFromJson(_obj, "state", state.get()) : new HttpPost<TimeStamp, WithTimeStamp<Model>>("/state", HashSetHelpers.create(Factories.arrayList("player")), new TypeToken<TimeStamp>(TimeStamp.jsonBinding()), new TypeToken<WithTimeStamp<Model>>(WithTimeStamp.jsonBinding(Model.jsonBinding())))
        );
      }
    };
  }
}
