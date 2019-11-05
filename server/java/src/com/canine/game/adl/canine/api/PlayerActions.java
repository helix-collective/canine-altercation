/* @generated from adl module canine.api */

package com.canine.game.adl.canine.api;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import org.adl.runtime.Builders;
import org.adl.runtime.Factories;
import org.adl.runtime.Factory;
import org.adl.runtime.JsonBinding;
import org.adl.runtime.JsonBindings;
import org.adl.runtime.Lazy;
import org.adl.runtime.sys.adlast.ScopedName;
import org.adl.runtime.sys.adlast.TypeExpr;
import org.adl.runtime.sys.adlast.TypeRef;
import java.util.ArrayList;
import java.util.Objects;

public class PlayerActions {

  /* Members */

  private ShipId id;
  private ArrayList<PlayerAction> actions;

  /* Constructors */

  public PlayerActions(ShipId id, ArrayList<PlayerAction> actions) {
    this.id = Objects.requireNonNull(id);
    this.actions = Objects.requireNonNull(actions);
  }

  public PlayerActions() {
    this.id = new ShipId();
    this.actions = new ArrayList<PlayerAction>();
  }

  public PlayerActions(PlayerActions other) {
    this.id = ShipId.FACTORY.create(other.id);
    this.actions = Factories.arrayList(PlayerAction.FACTORY).create(other.actions);
  }

  /* Accessors and mutators */

  public ShipId getId() {
    return id;
  }

  public void setId(ShipId id) {
    this.id = Objects.requireNonNull(id);
  }

  public ArrayList<PlayerAction> getActions() {
    return actions;
  }

  public void setActions(ArrayList<PlayerAction> actions) {
    this.actions = Objects.requireNonNull(actions);
  }

  /* Object level helpers */

  @Override
  public boolean equals(Object other0) {
    if (!(other0 instanceof PlayerActions)) {
      return false;
    }
    PlayerActions other = (PlayerActions) other0;
    return
      id.equals(other.id) &&
      actions.equals(other.actions);
  }

  @Override
  public int hashCode() {
    int _result = 1;
    _result = _result * 37 + id.hashCode();
    _result = _result * 37 + actions.hashCode();
    return _result;
  }

  /* Builder */

  public static class Builder {
    private ShipId id;
    private ArrayList<PlayerAction> actions;

    public Builder() {
      this.id = null;
      this.actions = null;
    }

    public Builder setId(ShipId id) {
      this.id = Objects.requireNonNull(id);
      return this;
    }

    public Builder setActions(ArrayList<PlayerAction> actions) {
      this.actions = Objects.requireNonNull(actions);
      return this;
    }

    public PlayerActions create() {
      Builders.checkFieldInitialized("PlayerActions", "id", id);
      Builders.checkFieldInitialized("PlayerActions", "actions", actions);
      return new PlayerActions(id, actions);
    }
  }

  /* Factory for construction of generic values */

  public static final Factory<PlayerActions> FACTORY = new Factory<PlayerActions>() {
    @Override
    public PlayerActions create() {
      return new PlayerActions();
    }

    @Override
    public PlayerActions create(PlayerActions other) {
      return new PlayerActions(other);
    }

    @Override
    public TypeExpr typeExpr() {
      ScopedName scopedName = new ScopedName("canine.api", "PlayerActions");
      ArrayList<TypeExpr> params = new ArrayList<>();
      return new TypeExpr(TypeRef.reference(scopedName), params);
    }
    @Override
    public JsonBinding<PlayerActions> jsonBinding() {
      return PlayerActions.jsonBinding();
    }
  };

  /* Json serialization */

  public static JsonBinding<PlayerActions> jsonBinding() {
    final Lazy<JsonBinding<ShipId>> id = new Lazy<>(() -> ShipId.jsonBinding());
    final Lazy<JsonBinding<ArrayList<PlayerAction>>> actions = new Lazy<>(() -> JsonBindings.arrayList(PlayerAction.jsonBinding()));
    final Factory<PlayerActions> _factory = FACTORY;

    return new JsonBinding<PlayerActions>() {
      @Override
      public Factory<PlayerActions> factory() {
        return _factory;
      }

      @Override
      public JsonElement toJson(PlayerActions _value) {
        JsonObject _result = new JsonObject();
        _result.add("id", id.get().toJson(_value.id));
        _result.add("actions", actions.get().toJson(_value.actions));
        return _result;
      }

      @Override
      public PlayerActions fromJson(JsonElement _json) {
        JsonObject _obj = JsonBindings.objectFromJson(_json);
        return new PlayerActions(
          JsonBindings.fieldFromJson(_obj, "id", id.get()),
          JsonBindings.fieldFromJson(_obj, "actions", actions.get())
        );
      }
    };
  }
}
