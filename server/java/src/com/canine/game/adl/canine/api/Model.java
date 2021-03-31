/* @generated from adl module canine.api */

package com.canine.game.adl.canine.api;

import com.google.gson.JsonElement;
import com.google.gson.JsonObject;
import org.adl.runtime.Builders;
import org.adl.runtime.Factory;
import org.adl.runtime.HashMapHelpers;
import org.adl.runtime.JsonBinding;
import org.adl.runtime.JsonBindings;
import org.adl.runtime.Lazy;
import org.adl.runtime.sys.adlast.ScopedName;
import org.adl.runtime.sys.adlast.TypeExpr;
import org.adl.runtime.sys.adlast.TypeRef;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Objects;

public class Model {

  /* Members */

  private HashMap<ShipId, Ship> ships;
  private HashMap<MissileId, Missile> missiles;

  /* Constructors */

  public Model(HashMap<ShipId, Ship> ships, HashMap<MissileId, Missile> missiles) {
    this.ships = Objects.requireNonNull(ships);
    this.missiles = Objects.requireNonNull(missiles);
  }

  public Model() {
    this.ships = HashMapHelpers.factory(ShipId.FACTORY, Ship.FACTORY).create();
    this.missiles = HashMapHelpers.factory(MissileId.FACTORY, Missile.FACTORY).create();
  }

  public Model(Model other) {
    this.ships = HashMapHelpers.factory(ShipId.FACTORY, Ship.FACTORY).create(other.ships);
    this.missiles = HashMapHelpers.factory(MissileId.FACTORY, Missile.FACTORY).create(other.missiles);
  }

  /* Accessors and mutators */

  public HashMap<ShipId, Ship> getShips() {
    return ships;
  }

  public void setShips(HashMap<ShipId, Ship> ships) {
    this.ships = Objects.requireNonNull(ships);
  }

  public HashMap<MissileId, Missile> getMissiles() {
    return missiles;
  }

  public void setMissiles(HashMap<MissileId, Missile> missiles) {
    this.missiles = Objects.requireNonNull(missiles);
  }

  /* Object level helpers */

  @Override
  public boolean equals(Object other0) {
    if (!(other0 instanceof Model)) {
      return false;
    }
    Model other = (Model) other0;
    return
      ships.equals(other.ships) &&
      missiles.equals(other.missiles);
  }

  @Override
  public int hashCode() {
    int _result = 1;
    _result = _result * 37 + ships.hashCode();
    _result = _result * 37 + missiles.hashCode();
    return _result;
  }

  /* Builder */

  public static class Builder {
    private HashMap<ShipId, Ship> ships;
    private HashMap<MissileId, Missile> missiles;

    public Builder() {
      this.ships = null;
      this.missiles = null;
    }

    public Builder setShips(HashMap<ShipId, Ship> ships) {
      this.ships = Objects.requireNonNull(ships);
      return this;
    }

    public Builder setMissiles(HashMap<MissileId, Missile> missiles) {
      this.missiles = Objects.requireNonNull(missiles);
      return this;
    }

    public Model create() {
      Builders.checkFieldInitialized("Model", "ships", ships);
      Builders.checkFieldInitialized("Model", "missiles", missiles);
      return new Model(ships, missiles);
    }
  }

  /* Factory for construction of generic values */

  public static final Factory<Model> FACTORY = new Factory<Model>() {
    @Override
    public Model create() {
      return new Model();
    }

    @Override
    public Model create(Model other) {
      return new Model(other);
    }

    @Override
    public TypeExpr typeExpr() {
      ScopedName scopedName = new ScopedName("canine.api", "Model");
      ArrayList<TypeExpr> params = new ArrayList<>();
      return new TypeExpr(TypeRef.reference(scopedName), params);
    }
    @Override
    public JsonBinding<Model> jsonBinding() {
      return Model.jsonBinding();
    }
  };

  /* Json serialization */

  public static JsonBinding<Model> jsonBinding() {
    final Lazy<JsonBinding<HashMap<ShipId, Ship>>> ships = new Lazy<>(() -> HashMapHelpers.jsonBinding(ShipId.jsonBinding(), Ship.jsonBinding()));
    final Lazy<JsonBinding<HashMap<MissileId, Missile>>> missiles = new Lazy<>(() -> HashMapHelpers.jsonBinding(MissileId.jsonBinding(), Missile.jsonBinding()));
    final Factory<Model> _factory = FACTORY;

    return new JsonBinding<Model>() {
      @Override
      public Factory<Model> factory() {
        return _factory;
      }

      @Override
      public JsonElement toJson(Model _value) {
        JsonObject _result = new JsonObject();
        _result.add("ships", ships.get().toJson(_value.ships));
        _result.add("missiles", missiles.get().toJson(_value.missiles));
        return _result;
      }

      @Override
      public Model fromJson(JsonElement _json) {
        JsonObject _obj = JsonBindings.objectFromJson(_json);
        return new Model(
          JsonBindings.fieldFromJson(_obj, "ships", ships.get()),
          JsonBindings.fieldFromJson(_obj, "missiles", missiles.get())
        );
      }
    };
  }
}
