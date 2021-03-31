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

public class Ship {

  /* Members */

  private PosVel pv;
  private byte remainingLives;

  /* Constructors */

  public Ship(PosVel pv, byte remainingLives) {
    this.pv = Objects.requireNonNull(pv);
    this.remainingLives = remainingLives;
  }

  public Ship() {
    this.pv = new PosVel();
    this.remainingLives = (byte)0;
  }

  public Ship(Ship other) {
    this.pv = PosVel.FACTORY.create(other.pv);
    this.remainingLives = other.remainingLives;
  }

  /* Accessors and mutators */

  public PosVel getPv() {
    return pv;
  }

  public void setPv(PosVel pv) {
    this.pv = Objects.requireNonNull(pv);
  }

  public byte getRemainingLives() {
    return remainingLives;
  }

  public void setRemainingLives(byte remainingLives) {
    this.remainingLives = remainingLives;
  }

  /* Object level helpers */

  @Override
  public boolean equals(Object other0) {
    if (!(other0 instanceof Ship)) {
      return false;
    }
    Ship other = (Ship) other0;
    return
      pv.equals(other.pv) &&
      remainingLives == other.remainingLives;
  }

  @Override
  public int hashCode() {
    int _result = 1;
    _result = _result * 37 + pv.hashCode();
    _result = _result * 37 + (int) remainingLives;
    return _result;
  }

  /* Builder */

  public static class Builder {
    private PosVel pv;
    private Byte remainingLives;

    public Builder() {
      this.pv = null;
      this.remainingLives = null;
    }

    public Builder setPv(PosVel pv) {
      this.pv = Objects.requireNonNull(pv);
      return this;
    }

    public Builder setRemainingLives(Byte remainingLives) {
      this.remainingLives = Objects.requireNonNull(remainingLives);
      return this;
    }

    public Ship create() {
      Builders.checkFieldInitialized("Ship", "pv", pv);
      Builders.checkFieldInitialized("Ship", "remainingLives", remainingLives);
      return new Ship(pv, remainingLives);
    }
  }

  /* Factory for construction of generic values */

  public static final Factory<Ship> FACTORY = new Factory<Ship>() {
    @Override
    public Ship create() {
      return new Ship();
    }

    @Override
    public Ship create(Ship other) {
      return new Ship(other);
    }

    @Override
    public TypeExpr typeExpr() {
      ScopedName scopedName = new ScopedName("canine.api", "Ship");
      ArrayList<TypeExpr> params = new ArrayList<>();
      return new TypeExpr(TypeRef.reference(scopedName), params);
    }
    @Override
    public JsonBinding<Ship> jsonBinding() {
      return Ship.jsonBinding();
    }
  };

  /* Json serialization */

  public static JsonBinding<Ship> jsonBinding() {
    final Lazy<JsonBinding<PosVel>> pv = new Lazy<>(() -> PosVel.jsonBinding());
    final Lazy<JsonBinding<Byte>> remainingLives = new Lazy<>(() -> JsonBindings.WORD8);
    final Factory<Ship> _factory = FACTORY;

    return new JsonBinding<Ship>() {
      @Override
      public Factory<Ship> factory() {
        return _factory;
      }

      @Override
      public JsonElement toJson(Ship _value) {
        JsonObject _result = new JsonObject();
        _result.add("pv", pv.get().toJson(_value.pv));
        _result.add("remainingLives", remainingLives.get().toJson(_value.remainingLives));
        return _result;
      }

      @Override
      public Ship fromJson(JsonElement _json) {
        JsonObject _obj = JsonBindings.objectFromJson(_json);
        return new Ship(
          JsonBindings.fieldFromJson(_obj, "pv", pv.get()),
          JsonBindings.fieldFromJson(_obj, "remainingLives", remainingLives.get())
        );
      }
    };
  }
}
